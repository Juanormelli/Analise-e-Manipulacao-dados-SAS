/*
Programa:AnaliseCorRegiao.sas
Autor: Juan Ormelli de Medeiros
Data: 15/03/2021
Versao:1.00

Descrição: Programa feito para descobrir as 5 cores mais vendidas do Sudeste


*/

proc sort data=cgdexcel.vendas;
  by CodProduto;
run;

proc sort data=cgdexcel.produtos;
  by CodProduto;
run;

data AnaliseCorEX7;
  merge cgdexcel.produtos (in=a)
        cgdexcel.vendas (in=b);
  by CodProduto;
  if a=b;
  keep CodProduto CodEstado QtdeVendida CodCor;
run;

proc sort data=work.analisecorex7;
  by CodEstado; 
run;

data AnaliseCorEX7;
  merge cgdexcel.estados (in=a)
        work.analisecorex7 (in=b);
  by CodEstado;
  if a=b;
  keep CodProduto QtdeVendida CodRegiao CodCor;
run;
proc sort data=work.analisecorex7;
  by CodRegiao; 
run;
data AnaliseCorEX7;
  merge work.analisecorex7
        cgdexcel.regioes (rename=Nome=Regiao);
  by CodRegiao;
  keep Regiao QtdeVendida CodCor;
run;


data AnaliseCorEx7ATT;
  set work.analisecorex7;
  where Regiao="Sudeste";
run;

proc sort data=work.analisecorex7att;
  by CodCor;
run;

data AnaliseCorEX7Final;
  set work.analisecorex7att;
  by CodCor;
  if first.CodCor then TotalVendasCor=QtdeVendida;
  else TotalVendasCor+QtdeVendida;
  if last.CodCor;
  keep CodCor Regiao TotalVendasCor;
run;
data AnaliseCorEX7Final;
  merge work.analisecorex7final (in=a)
        cgdexcel.cores (in=b rename=descricao=Cor);
  by CodCor;
  if a=b;
  keep Cor TotalVendasCor;
run;

proc sort data=work.analisecorex7final;
  by descending TotalVendasCor;
run;

Title "5 Cores Mais Vendidas na Regiao Sudeste";
proc print data=work.analisecorex7final (obs=5);
  var Cor TotalVendasCor; 
run;
