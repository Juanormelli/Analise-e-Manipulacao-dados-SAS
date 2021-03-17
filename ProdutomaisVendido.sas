/*
Programa:ProdutoMaisVendido.sas
Autor: Juan Ormelli de Medeiros
Data:12/03/2021
Versao:1.00

Descrição:Programa para filtrar o Produto mais vendido, nas tabelas de carga de dados  


*/
proc sort data=cgdexcel.produtos;
  by CodProduto;
run;

proc sort data=cgdexcel.vendas;
  by CodProduto;
run;

data AnaliseEx7;
  merge cgdexcel.vendas (in=a)
    cgdexcel.produtos (in=b);
  by CodProduto;

  if a=b;
  keep Descricao CodProduto QtdeVendida;
run;

data ProdutoMaisVendido;
  set work.analiseex7;
  by CodProduto;

  if first.CodProduto then
    SomaDeVendas=qtdevendida;
  else SomaDeVendas+qtdevendida;

  if last.CodProduto;
  keep CodProduto Descricao SomaDeVendas;

proc sort data=work.produtomaisvendido;
  by descending SomaDeVendas;
run;

title "Produto Mais Vendido";

proc print data=work.produtomaisvendido (obs=1);
run;

