/*
Programa:AnalisePeriodo.sas
Autor: Juan Ormelli de Medeiros
Data:15/03/2021 
Versao:1.00

Descrição:Programa para analise de vendas por mes 


*/

proc sort data=cgdexcel.vendas;
  by DataVenda;
run;
Data AnalisePeriodos;
  set cgdexcel.vendas;
  Mes=month(DataVenda);
  Ano=year(DataVenda);
  DataReferencia=DataVenda;
  format DataReferencia MONYY.;
run;
proc sort data=work.analiseperiodos;
  by Mes;
run;

data AnalisePeriodos;
  set work.analiseperiodos;
  by Mes Ano;
  if first.mes or first.ano then TotalVendas=QtdeVendida;
  else TotalVendas+QtdeVendida;
  if  last.mes or last.ano;
run;

proc sort data=work.analiseperiodos;
  by descending TotalVendas;
run;
title "Mes e Ano em que Obtivemos o maior numero de Vendas";
Proc Print data=work.analiseperiodos (obs=1);
var DataReferencia TotalVendas;
run;




