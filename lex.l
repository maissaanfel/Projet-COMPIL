/*BENABED ANFEL 171731030391*/
/*BOUACHAT ANFEL 181831041144*/
%{
	#include "synt.tab.h"
	#include "TS.h"
	int nb_ligne=1;
	extern YYSTYPE yylval;
%}


lettresM [A-Z]
lettres [a-zA-Z]
IDF {lettresM}({lettres}|[0-9])*
Chaine \"[^\"]*\"
const_int ([1-9][0-9]*|0)
const_int_neg [-]([1-9][0-9]*|0)
const_char \'lettres\' 
const_reel [1-9]+\.[0-9]+
const_reel_neg [-][1-9]+\.[0-9]+
commentaire \/\/.*\n|\/\*([^*]|[\r\n]|(\*+([^*\/]|[\r\n])))*\*+\/

%%
Programme { rechercher (yytext,"Mot cle "," ",0, 1); return mc_prg;}
INTEGER { yylval.str=strdup(yytext); rechercher (yytext,"Mot cle "," ",0, 1); return mc_integer;}
REAL { yylval.str=strdup(yytext); rechercher (yytext,"Mot cle "," ",0, 1); return mc_real;}
CHAR { yylval.str=strdup(yytext); rechercher (yytext,"Mot cle "," ",0, 1); return mc_char;}
STRING { yylval.str=strdup(yytext); rechercher (yytext,"Mot cle "," ",0, 1); return mc_string;}
CONST { yylval.str=strdup(yytext); rechercher (yytext,"Mot cle "," ",0, 1); return mc_const;}
PROCESS[ \t]*[\n] { nb_ligne++; rechercher (yytext,"Mot cle "," ",0, 1); return bib_proc;}
LOOP[ \t]*[\n] {nb_ligne++; rechercher (yytext,"Mot cle "," ",0, 1); return bib_loop;}
ARRAY[ \t]*[\n] {nb_ligne++; rechercher (yytext,"Mot cle "," ",0, 1); return bib_array;}
EXECUT { rechercher (yytext,"Mot cle "," ",0, 1); return mc_condition;}
WHILE { rechercher (yytext,"Mot cle "," ",0, 1); return mc_while;}
IF { rechercher (yytext,"Mot cle "," ",0, 1); return mc_if;}
END_IF { rechercher (yytext,"Mot cle "," ",0, 1); return mc_fsi;}
ELSE { rechercher (yytext,"Mot cle "," ",0, 1); return mc_else;}
READ { rechercher (yytext,"Mot cle "," ",0, 1); return mc_read;}
WRITE { rechercher (yytext,"Mot cle "," ",0, 1); return mc_write;}
INF return inferior;
SUP return superior;
EG return egale;
DIFF return different;
INFE return infeg;
SUPE return supeg;
VAR { rechercher (yytext,"Mot cle "," ",0, 1); return mc_var;}
"//" { rechercher (yytext,"Separateur",0,0, 2); return separateur; }
{IDF}  {
	rechercher (yytext,"IDF"," ",0, 0);
	if (yyleng<10) { yylval.str=strdup(yytext);
			                    return idf;
							  }
                else printf ("Erreur lexicale: IDF trop long %s a la ligne %d\n", yytext, nb_ligne);
		}
{Chaine} { rechercher (yytext,"Cst string ","string",atof(yytext), 0); yylval.str=strdup(yytext); return chaine;}
{const_int} { yylval.entier=atoi(yytext);
			rechercher (yytext,"Cst entiere ","entier",atof(yytext), 0);
			if ((abs(atoi(yytext)))<= 32767) return const_int;
			else printf("Erreur: Entier depasse son intervalle.\n");
			}
{const_int_neg} {yylval.entier=atoi(yytext); rechercher (yytext,"Cst entiere ","entier",atof(yytext), 0);
			if ((abs(atoi(yytext)))>= -32786) return const_int_neg;
			else printf("Erreur: Entier depasse son intervalle.\n");}
{const_char} {
			rechercher (yytext,"Cst caractere","char",atof(yytext), 0);
			if (yyleng < 4) return const_char;
			else printf("Erreur: Taille grande pour un caractere\n");
			}
{const_reel} { yylval.str=strdup(yytext); rechercher (yytext,"Cst reel ","reel",atof(yytext), 0); return const_reel;}
{const_reel_neg} { yylval.reel=atof(yytext); rechercher (yytext,"Cst reel ","reel",atof(yytext), 0); return const_reel_neg;}
{commentaire} {return commentaire;}
"$" { rechercher (yytext,"Separateur",0,0, 2); return dlr;}
"::" { rechercher (yytext,"Separateur",0,0, 2); return ddp;} //2 double point 
":=" return aff;
"##" { rechercher (yytext,"Separateur",0,0, 2); return include;}
"|" { rechercher (yytext,"Separateur",0,0, 2); return sep;} 
" ; " { rechercher (yytext,"Separateur",0,0, 2); return pvg; }
"?" { rechercher (yytext,"Separateur",0,0, 2); return sfs; }
"%" { rechercher (yytext,"Separateur",0,0, 2); return sfr; }
"&" { rechercher (yytext,"Separateur",0,0, 2); return sfc; }
"@" { rechercher (yytext,"Separateur",0,0, 2); return at;}
"{" { rechercher (yytext,"Separateur",0,0, 2); return aco_ov;}
"}" { rechercher (yytext,"Separateur",0,0, 2); return aco_fr;}
"[" { rechercher (yytext,"Separateur",0,0, 2); return cr_ov;}
"]" { rechercher (yytext,"Separateur",0,0, 2); return cr_fm;}
[(] { rechercher (yytext,"Separateur",0,0, 2); return par_ouv;}
[)] { rechercher (yytext,"Separateur",0,0, 2); return par_frm;}
["] { rechercher (yytext,"Separateur",0,0, 2); return guillemet;}
['] { rechercher (yytext,"Separateur",0,0, 2); return apst;}
" + " { rechercher (yytext,"Separateur",0,0, 2); return add;}
" - " { rechercher (yytext,"Separateur",0,0, 2); return sub;}
"*" { rechercher (yytext,"Separateur",0,0, 2); return produit;}
"/" { rechercher (yytext,"Separateur",0,0, 2); return division; } 
[ \t] 
[\n] nb_ligne++;
. {printf("erreur lexicale a ligne %d sur l'entite %s\n",nb_ligne,yytext);
   return err;  }
