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
  
 
run;

proc sort data=work.analiseperiodosmesano;
  by DataVenda ;
run;
title "Analise de Vendas de "&Datas_Min" Ate "&Datas_Max" ";
proc print data=work.analiseperiodosmesano;
	var DataVenda Descricao QtdeVendida PrecoUnitario totalvendas ;
  format AcumuladoMes AcumuladoAno comma20.2;
  where DataVenda between"&Datas_Min"d and "&Datas_Max"d;
run;


