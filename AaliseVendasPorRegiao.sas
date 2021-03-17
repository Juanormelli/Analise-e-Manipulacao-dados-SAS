/*
Programa:AnaliseVendasPorRegiao.sas
Autor: Juan Ormelli de Medeiros
Data:15/03/2021 
Versao:1.00

Descrição:Programa para analisar vendas por regiao das tabelas da carga de dados 


*/

proc sort data=cgdexcel.vendas;
  by CodProduto;
run;

proc sort data=cgdexcel.produtos;
  by CodProduto;
run;

data AnaliseProdutosRegiaoEX7;
  merge cgdexcel.produtos (in=a)
        cgdexcel.vendas (in=b);
  by CodProduto;
  if a=b;
  keep CodProduto CodEstado QtdeVendida;
run;

proc sort data=work.analiseprodutosregiaoex7;
  by CodEstado; 
run;

data AnaliseProdutosRegiaoEX7;
  merge cgdexcel.estados (in=a)
        work.analiseprodutosregiaoex7 (in=b);
  by CodEstado;
  if a=b;
  keep CodProduto QtdeVendida CodRegiao;
run;

Proc sort data=work.analiseprodutosregiaoex7;
  by CodProduto CodRegiao;
run;


data FinalAnaliseProdutosRegiao;
  set work.analiseprodutosregiaoex7;
  by CodProduto CodRegiao;
  if first.CodProduto or first.CodRegiao then TotalVendas= QtdeVendida;
  else TotalVendas+QtdeVendida;
  
run;
proc sort data=work.finalanaliseprodutosregiao;
  by CodRegiao;
run;


proc sort data=work.finalanaliseprodutosregiao;
  by descending TotalVendas;
run;
proc sort data=work.finalanaliseprodutosregiao;
  by CodRegiao;
run;
data FinalAnaliseProdutosRegiao;
  set work.finalanaliseprodutosregiao;
  by CodRegiao;
  if first.CodRegiao;

run;

data FinalAnaliseProdutosRegiao;
  merge cgdexcel.regioes (in=a)
        work.finalanaliseprodutosregiao (in=b);
  by CodRegiao;
  if a=b;
  keep Nome CodProduto TotalVendas;
run;

title "Produtos mais Vendidos por Regiao";
proc print data=work.finalanaliseprodutosregiao;
  var Nome CodProduto TotalVendas;
run;
