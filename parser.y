%{
#include <stdio.h>
#include<stdlib.h>

int yylex();
void yyerror(char *s);

struct Ulamek{
	int dzielna;
	int dzielnik;
};

int gcd(int a, int b);

void skrucenie(struct Ulamek *u){
	int dzielna1 = u -> dzielna;
	int dzielnik1 = u -> dzielnik;
	int gcd1 = gcd(dzielna1, dzielnik1);
	u -> dzielna = dzielna1 / gcd1;
	u -> dzielnik = dzielnik1 / gcd1;
}

int gcd(int a, int b){
	while (b != 0){
		int temp = b;
		b = a % b;
		a = temp;
	}
	return a;
}

int obliczone = 0;

%}

%union{
	int calkowita;
	struct Ulamek *ulamek;
}

%token <calkowita> DZIELNA DZIELNIK PLUS MINUS TO_JEDYNE DZIELENIE OTWARCIE ZAMKNIECIE

%type <ulamek> wyrazenie plus_i_minus co_widze liczba

%left PLUS MINUS
%left TO_JEDYNE DZIELENIE

%%

start:
	| start linia
	;

linia:
     	'\n'
	| wyrazenie {
		printf("%d|%d\n", $1->dzielna, $1->dzielnik);
		obliczone++;
	}
	;

wyrazenie:
	wyrazenie PLUS plus_i_minus{
		struct Ulamek *u = malloc(sizeof (*u));
		u -> dzielna = $1->dzielna * $3->dzielnik + $3->dzielna * $1->dzielnik;
		u -> dzielnik = $1->dzielnik * $3->dzielnik;
		skrucenie(u);
		$$ = u;
	}
	|
	wyrazenie MINUS plus_i_minus{
		struct Ulamek *u = malloc(sizeof (*u));
		u -> dzielna = $1->dzielna * $3->dzielnik - $3->dzielna*$1->dzielnik;
		u -> dzielnik = $1->dzielnik * $3->dzielnik;
		skrucenie(u);
		$$ = u;
	}
	|
	plus_i_minus{
		$$ = $1;
	}
	;

plus_i_minus:
	plus_i_minus TO_JEDYNE  co_widze{
		struct Ulamek *u = malloc(sizeof(*u));
		u -> dzielna = $1->dzielna * $3->dzielna;
		u -> dzielnik = $1->dzielnik * $3->dzielnik;
		skrucenie(u);
		$$ = u;
	}
	|
	plus_i_minus DZIELENIE co_widze{
		struct Ulamek *u = malloc(sizeof(*u));
		u->dzielna = $1->dzielna * $3->dzielnik;
		u->dzielnik = $1->dzielnik *$3->dzielna;
		skrucenie(u);
		$$ = u;
	}
	|
	co_widze{
		$$ = $1;
	}
	;
co_widze:
	liczba{
	$$ = $1;
	}
	|
	OTWARCIE wyrazenie ZAMKNIECIE{
		$$ = $2;
	}
	;
liczba:
	DZIELNA DZIELNIK{
		struct Ulamek *u = malloc(sizeof(*u));
		u->dzielna = $1;
		u->dzielnik = $2;
		skrucenie(u);
		$$ = u;
	}
	| MINUS DZIELNA DZIELNIK{
		struct Ulamek *u = malloc(sizeof(*u));
		u->dzielna = -$2;
		u->dzielnik = $3;
		skrucenie(u);
		$$ = u;
	}
	;
%%

void yyerror(char *s){
	printf("Niepoprawne wyrazenie, liczba poprawnie obliczonych wyrazen: %d\n", obliczone);
}

int main(){
	yyparse();
	return 0;

}


