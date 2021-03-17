/*
Programa:QuebraMesAno.sas
Autor: Juan Ormelli de Medeiros
Data: 15/03/2021
Versao:1.00

Descrição:Programa para calcular o acumulado de Mes e ano com quebras por mes e ano


*/


proc sort data=cgdexcel.produtos;
  by CodProduto;
run;
proc sort data=cgdexcel.vendas;
  by CodProduto;
run;

data AnaliseMesAno;
	merge work.vendassort (in=a)
	  	work.produtosort(in=b);
	by CodProduto;
	if a=b;
run;
Data AnalisePeriodosMesAno;
  set work.Analisemesano;
  Mes=month(DataVenda);
  Ano=year(DataVenda);
run;
proc sort data=work.analiseperiodosmesano;
  by mes ano;

data AnalisePeriodosMesAno;
  set work.analiseperiodosmesano;
  by Mes Ano;
  if first.mes  then totalvendas=precounitario*qtdevendida ;
	else totalvendas=precounitario*qtdevendida;
  if first.mes or First.ano then AcumuladoMes=totalvendas;
  else AcumuladoMes+totalvendas;
 
run;
proc sort data=work.analiseperiodosmesano;
  by ano ;
run;

data AnalisePeriodosMesAno;
  set work.analiseperiodosmesano;
  by Ano mes ;
  if first.Ano then AcumuladoAno=totalvendas ;
  else AcumuladoAno+totalvendas;
 
run;
title "Analise de Quebras Por mes e ano";
proc print data=work.analiseperiodosmesano;
	var Mes Ano Descricao QtdeVendida PrecoUnitario totalvendas AcumuladoMes 
	AcumuladoAno;
  format AcumuladoMes AcumuladoAno comma20.2;
run;
