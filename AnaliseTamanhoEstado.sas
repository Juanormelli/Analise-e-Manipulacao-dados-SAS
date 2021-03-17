/*
Programa:AnaliseTamanhoEstado.sas
Autor: Juan Ormelli de Medeiros
Data: 15/03/2021
Versao:1.00

Descrição: Programa feito para analise de tamanho mais vendido em cada estado


*/

proc sort data=cgdexcel.vendas;
  by CodEstado;
run;
proc sort data=cgdexcel.estados;
  by CodEstado;
run;

data AnaliseTamanhoEX7;
  merge cgdexcel.estados (in=a)
        cgdexcel.vendas (in=b);
  by CodEstado;
  if a=b;
  keep CodTamanho QtdeVendida CodEstado Nome;
run;

proc sort data=work.analisetamanhoex7;
  by CodTamanho CodEstado;
run;

Data AnaliseTamanhoEX7;
  
  set work.Analisetamanhoex7;
 
  by CodTamanho CodEstado;
  if first.CodTamanho or first.CodEstado then TotalVendas=QtdeVendida;
  else TotalVendas+QtdeVendida;
  
run;

proc sort data=work.analisetamanhoex7;
  by CodEstado;
run;
proc sort data=work.analisetamanhoex7;
  by descending TotalVendas;
run;
proc sort data=work.analisetamanhoex7;
  by CodEstado;
run;
data FinalAnaliseTamanhoRegiao;
  set work.analisetamanhoex7;
  by CodEstado;
  if first.CodEstado;
  keep Nome CodTamanho TotalVendas;
run;

title "Tamanho mais vendido em cada Regiao ";
proc print data=work.finalanalisetamanhoregiao;
var Nome CodTamanho TotalVendas;
run;

