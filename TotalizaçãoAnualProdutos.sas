/*
Programa:TotalizaçãoAnualProdutos.sas
Autor: Juan Ormelli de Medeiros
Data:16/03/2021 
Versao:1.00

Descrição:Programa para efetuar a totalização de Quantidades e valor total de produtos vendido por ano 


*/

proc sort data=cgdexcel.produtos;
  by CodProduto;
run;

proc sort data=cgdexcel.vendas;
  by CodProduto;
run;

data TotalAnualProduto_merge;
  merge cgdexcel.vendas (in=a)
        cgdexcel.produtos(in=b);
  by CodProduto;
  if a=b;
run;

data TotalAnualProduto;
  set work.totalanualProduto_merge;
  Ano=year(DataVenda);
  keep ano CodProduto QtdeVendida PrecoUnitario;
run;

proc sort data=work.totalanualProduto;
  by CodProduto ano;
run;

data TotalAnualProduto;
  set work.totalanualProduto;
  by CodProduto Ano;
  if first.CodProduto or first.Ano then QtdeTotalVendida=QtdeVendida;
  else QtdeTotalVendida+QtdeVendida;
  if first.CodProduto or first.Ano then ValorTotaldeVendas=QtdeVendida*precounitario;
  else ValorTotaldeVendas+(QtdeVendida*PrecoUnitario);
  if last.CodProduto or last.Ano;
  format ValorTotaldeVendas comma20.2 QtdeTotalVendida comma10.0;
  keep Ano CodProduto QtdeTotalVendida ValorTotaldeVendas;
run;
data TotalAnualProduto;
  merge cgdexcel.Produtos (in=a rename=descricao=Produto)
        work.totalanualProduto (in=b);
  by CodProduto;
  if a=b;
run;

proc sort data=work.totalanualProduto;
  by Ano;
run;

title "Totalização Anual Qtde e Valor Total por Produto";
proc print data=work.totalanualProduto;
  by ano;
  var Produto QtdeTotalVendida ValorTotaldeVendas;
run;