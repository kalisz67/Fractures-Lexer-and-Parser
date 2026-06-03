%option noyywrap

%{
#include <stdio.h>
#include <stdlib.h>
#include "parser.tab.h"
%}

numbers		([0-9])+

%%
{numbers}	{
			yylval.calkowita = atoi(yytext);
			return DZIELNA;
		}
"|"{numbers}		{
			yylval.calkowita = atoi(yytext+1);
			return DZIELNIK;
			
		}
"+"		return PLUS;
"-"		return MINUS;
"*"		return TO_JEDYNE;
"/"		return DZIELENIE;
"("		return OTWARCIE;
")"		return ZAMKNIECIE;
[ \t]		;
.		;
%%
