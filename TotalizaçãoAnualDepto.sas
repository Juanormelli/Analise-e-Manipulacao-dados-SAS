/*
Programa:TotalizaçãoAnualDepto.sas
Autor: Juan Ormelli de Medeiros
Data: 16/03/2021
Versao:1.00

Descrição: Programa para elaborar a totalização de vendas e quantidade de vendas por Departamento


*/


proc sort data=cgdexcel.produtos;
  by CodProduto;
run;

proc sort data=cgdexcel.vendas;
  by CodProduto;
run;

data TotalAnualDepto_merge;
  merge cgdexcel.vendas (in=a)
        cgdexcel.produtos(in=b);
  by CodProduto;
  if a=b;
run;

data TotalAnualDepto;
  set work.totalanualdepto_merge;
  Ano=year(DataVenda);
  keep ano CodDepto QtdeVendida PrecoUnitario;
run;

proc sort data=work.TOTALANUALDEPTO;
  by CodDepto ano;
run;

data TotalAnualDepto;
  set work.totalanualdepto;
  by CodDepto Ano;
  if first.CodDepto or first.Ano then QtdeTotalVendida=QtdeVendida;
  else QtdeTotalVendida+QtdeVendida;
  if first.CodDepto or first.Ano then ValorTotaldeVendas=QtdeVendida*precounitario;
  else ValorTotaldeVendas+(QtdeVendida*PrecoUnitario);
  if last.CodDepto or last.Ano;
  format ValorTotaldeVendas comma20.2 QtdeTotalVendida comma10.0;
  keep Ano CodDepto QtdeTotalVendida ValorTotaldeVendas;
run;
data TotalAnualDepto;
  merge cgdexcel.deptos (in=a rename=descricao=Departamento)
        work.totalanualdepto (in=b);
  by CodDepto;
  if a=b;
run;

proc sort data=work.totalanualdepto;
  by Ano;
run;

title "Totalização Anual Qtde e Valor Total por Depto";
proc print data=work.totalanualdepto;
  by ano;
  var Departamento QtdeTotalVendida ValorTotaldeVendas;
run;