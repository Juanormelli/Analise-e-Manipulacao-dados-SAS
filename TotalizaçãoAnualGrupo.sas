/*
Programa:TotalizaçãoAnualGrupo.sas
Autor: Juan Ormelli de Medeiros
Data: 16/03/2021    
Versao:1.00

Descrição:Programa para efetuar a totalização anual de vendas e quantidade vendidas por grupo 


*/

proc sort data=cgdexcel.produtos;
  by CodProduto;
run;

proc sort data=cgdexcel.vendas;
  by CodProduto;
run;

data TotalAnualGrupo_merge;
  merge cgdexcel.vendas (in=a)
        cgdexcel.produtos(in=b);
  by CodProduto;
  if a=b;
run;

data TotalAnualGrupo;
  set work.totalanualgrupo_merge;
  Ano=year(DataVenda);
  keep ano CodGrupo QtdeVendida PrecoUnitario;
run;

proc sort data=work.totalanualgrupo;
  by CodGrupo ano;
run;

data TotalAnualGrupo;
  set work.totalanualgrupo;
  by CodGrupo Ano;
  if first.CodGrupo or first.Ano then QtdeTotalVendida=QtdeVendida;
  else QtdeTotalVendida+QtdeVendida;
  if first.CodGrupo or first.Ano then ValorTotaldeVendas=QtdeVendida*precounitario;
  else ValorTotaldeVendas+(QtdeVendida*PrecoUnitario);
  if last.CodGrupo or last.Ano;
  format ValorTotaldeVendas comma20.2 QtdeTotalVendida comma10.0;
  keep Ano CodGrupo QtdeTotalVendida ValorTotaldeVendas;
run;
data TotalAnualGrupo;
  merge cgdexcel.grupos (in=a rename=descricao=Grupo)
        work.totalanualgrupo (in=b);
  by CodGrupo;
  if a=b;
run;

proc sort data=work.totalanualgrupo;
  by Ano;
run;

title "Totalização Anual Qtde e Valor Total por Grupo";
proc print data=work.totalanualgrupo;
  by ano;
  var Grupo QtdeTotalVendida ValorTotaldeVendas;
run;
