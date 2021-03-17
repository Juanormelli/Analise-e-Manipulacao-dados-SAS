/*
Programa:PulandoLinhas.sas
Autor: Juan Ormelli de Medeiros
Data: 12/03/2021
Versao:1.00

Descrição: Programa Elaborado para pular linhas de acordo com quebra de grupos e departamentos 


*/


proc report data=cgdexcel.atttestetable nowd headskip
   style(header)=[backgroundcolor=lightblue];
    column CodDepto CodGrupo AcumuladoGrupo AcumuladoDepto;
    define AcumuladoGrupo / format=comma25.2;
    define AcumuladoDepto / format=comma25.2;
    define CodGrupo / order;
    define CodDepto / order;
    compute After CodGrupo/style=[backgroundcolor=yellow];
      line"";
    endcomp;
    compute before CodGrupo/style=[backgroundcolor=Blue];
      line"";
    endcomp;
run;