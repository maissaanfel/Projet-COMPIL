/*BENABED ANFEL 171731030391*/
/*BOUACHAT ANFEL 181831041144*/
%{
#include <string.h>
char sauvType[20];
char sauvConst [20];
char VAR[20];
int Bib[3]={0,0,0}; // Bib[0] process Bib[1] Array Bib[2] Loop
int NbIDF =0;
char* tabIDF[20];
char tabSigne [20];
extern unsigned int nb_ligne;
%}
%union 
{ 
   int entier;
   float reel;
   char* str;
}
%token mc_prg <str>mc_integer <str>mc_real <str>mc_char <str>mc_string <str>mc_const mc_while <str>chaine err 
	   bib_proc bib_loop bib_array mc_condition mc_if mc_fsi egale different 
	   mc_else mc_read mc_write inferior superior mc_var separateur supeg infeg 
	   <str>idf dlr ddp aff include sep sfs sfr sfc at aco_ov cr_fm cr_ov
	   aco_fr par_ouv par_frm guillemet add sub produit division commentaire pvg apst
	   <entier>const_int const_char <str>const_reel <reel>const_reel_neg <entier>const_int_neg
%type <str>CONST
%type <str>LISTE_OP
%type <str>SIGNE_DE_FORMATAGE
%start S 
%%
S : LISTE_BIB  mc_prg idf aco_ov LISTE_DEC CORPS aco_fr 
			{printf("programme syntaxiquement correct.\n"); YYACCEPT;}
;

CORPS:BOUCLE CORPS
      | LECTURE CORPS
      | ECRITURE CORPS
      | commentaire CORPS
	  | AFFECTATION CORPS
	  | CONDITIONS CORPS
	  | 
;
LISTE_DEC: DEC LISTE_DEC
          |
;
DEC: DEC_VAR
     |DEC_TAB
     |DEC_CST
;
DEC_VAR: mc_var TYPE ddp LISTE_IDF dlr
;
DEC_CST: mc_const TYPE ddp LISTE_IDF_cst dlr
;
DEC_TAB: TYPE LISTE_IDF_TAB dlr
;
LISTE_IDF_TAB: idf cr_ov CONST cr_fm separateur LISTE_IDF_TAB 
				{
					if (Bib[1] == 0) printf("Erreur semantique: Bibliotheque Array non declaree\n");
					if(DoubleDec($1)==0)   { insererTYPE($1,sauvType);}
					else printf("Erreur semantique: Double declaration  de %s a la ligne %d\n",$1,nb_ligne);
					if ($3<0) printf("Erreur semantique: la taille de tableau %d doit etre positive a la ligne %d\n ",$5,nb_ligne);
				}
				|idf cr_ov CONST cr_fm 
				{
					if ($3<0)
					printf("Erreur semantique: la taille de tableau %d doit etre positive a la ligne %d \n ",$3,nb_ligne);
				}
;
LISTE_IDF: idf separateur LISTE_IDF { if(DoubleDec($1)==0)   { insererTYPE($1,sauvType);}
							    else 
								printf("Erreur semantique: Double declaration  de %s a la ligne %d\n",$1,nb_ligne);
							  }
			| idf 					{ if(DoubleDec($1)==0) 	  { insererTYPE($1,sauvType); }
							    else 
								printf("Erreur semantique: double declaration  de %s a la ligne %d\n",$1,nb_ligne);
							  }
;
LISTE_IDF_cst: idf aff CONST LISTE_IDF_cst { if(DoubleDec($1)==0)   { insererTYPE($1,sauvType);}
							    else 
								printf("Erreur semantique: Double declaration  de %s a la ligne %d\n",$1,nb_ligne);
							  }
				| idf aff CONST { if(DoubleDec($1)==0) 	  { insererTYPE($1,sauvType); }
							    else 
								printf("Erreur semantique: double declaration  de %s a la ligne %d\n",$1,nb_ligne);
							  }
;
AFFECTATION:idf aff CONST dlr 
						{strcpy(VAR,$1);
					    if(Declaration($1)==0)
					   { printf("Erreur semantique : variable %s non declaree ==> L%d\n",$1,nb_ligne);}
					   if(strcmp((char*)getType(VAR),(char*)getType($3))!=0)
						{ printf("Erreur semantique : Non compatibilite de type ==> L%d\n",nb_ligne);}}
          | idf aff idf dlr 
		               {strcpy(VAR,$1);
					   if(Declaration($1)==0)
					   { printf("Erreur semantique : variable %s non declaree ==> L%d\n",$1,nb_ligne);}
					   if(strcmp((char*)getType(VAR),(char*)getType($3))!=0)
						{ printf("Erreur semantique : Non compatibilite de type ==> L%d\n",nb_ligne);}}
          | idf aff OPERATION dlr
						{strcpy(VAR,$1);
					   if(Declaration($1)==0)
					   { printf("Erreur semantique : variable %s non declaree ==> L%d\n",$1,nb_ligne);}}
;
OPERATION: CONST LISTE_OP CONST
					{ if(Bib[0] == 0) printf("Erreur semantique: Bibliotheque Process non declaree.\n");
					if(strcmp((char*)getType($1),(char*)getType($3))!=0)
						{ printf("Erreur semantique : Non compatibilite de type ==> L%d\n",nb_ligne);}
					if(strcmp((char*)$2,"/")==0) { if($3==0) { printf("Erreur semantique :Division par Zero ==> L%d\n",nb_ligne); }}}
        | CONST LISTE_OP idf
					{ if(Bib[0] == 0) printf("Erreur semantique: Bibliotheque Process non declaree.\n");
					if(Declaration($3)==0)
					   { printf("Erreur semantique : variable %s non declaree ==> L%d\n",$1,nb_ligne);}
					if(strcmp((char*)getType($1),(char*)getType($3))!=0)
						{ printf("Erreur semantique : Non compatibilite de type ==> L%d\n",nb_ligne);}}
        | idf LISTE_OP CONST
					{ if(Bib[0] == 0) printf("Erreur semantique: Bibliotheque Process non declaree.\n");
					if(Declaration($1)==0)
					   { printf("Erreur semantique : variable %s non declaree ==> L%d\n",$1,nb_ligne);}
					if(strcmp((char*)getType($1),(char*)getType($3))!=0)
						{ printf("Erreur semantique : Non compatibilite de type ==> L%d\n",nb_ligne);}
					if(strcmp((char*)$2,"/")==0) { if($3==0) { printf("Erreur semantique :Division par Zero ==> L%d\n",nb_ligne); }}}
        | idf LISTE_OP idf
					{ if(Bib[0] == 0) printf("Erreur semantique: Bibliotheque Process non declaree.\n");
					if(Declaration($1)==0)
					   { printf("Erreur semantique : variable %s non declaree ==> L%d\n",$1,nb_ligne);}
					if(Declaration($3)==0)
					   { printf("Erreur semantique : variable %s non declaree ==> L%d\n",$1,nb_ligne);}
					if(strcmp((char*)getType($1),(char*)getType($3))!=0)
						{ printf("Erreur semantique : Non compatibilite de type ==> L%d\n",nb_ligne);}
					}
;
LISTE_OP: add 
        |sub 
        |produit 
        |division 
;
LISTE_COMPARAISON: superior
                  | inferior
                  | egale
                  | supeg
                  | infeg
                  | different
;
BOUCLE: mc_while par_ouv COMPARAISON par_frm aco_ov BLOC_INST aco_fr dlr
			{ if(Bib[2] == 0) printf("Erreur semantique: Bibliotheque Loop non declaree.\n"); }
;
CONDITIONS: mc_condition BLOC_INST mc_if par_ouv COMPARAISON par_frm dlr
			| mc_condition BLOC_INST mc_if par_ouv COMPARAISON par_frm mc_else BLOC_INST mc_fsi dlr
;

COMPARAISON: CONST LISTE_COMPARAISON CONST
          | CONST LISTE_COMPARAISON idf
			{if(Declaration($3)==0)
					   { printf("Erreur semantique : variable %s non declaree ==> L%d\n",$1,nb_ligne);}}
          | idf LISTE_COMPARAISON idf
			{if(Declaration($1)==0)
					   { printf("Erreur semantique : variable %s non declaree ==> L%d\n",$1,nb_ligne);}
			if(Declaration($3)==0)
					   { printf("Erreur semantique : variable %s non declaree ==> L%d\n",$1,nb_ligne);}}
          | idf LISTE_COMPARAISON CONST
			{if(Declaration($1)==0)
					   { printf("Erreur semantique : variable %s non declaree ==> L%d\n",$1,nb_ligne);}}
;
CONST: const_char { strcpy(sauvConst,(char*)$1) ; }
		| const_int { strcpy(sauvConst, (char*)$1) ; }
		| const_reel { strcpy(sauvConst, (char*)$1); }
		| chaine { strcpy(sauvConst,$1) ; }
		| par_ouv const_int_neg par_frm { strcpy(sauvConst,$1) ; }
		| par_ouv const_reel_neg par_frm { strcpy(sauvConst,$1) ; } 
;
LECTURE: mc_read par_ouv guillemet SIGNE_DE_FORMATAGE guillemet sep at idf par_frm dlr
			{if(Declaration($8)==0)
				{printf("Erreur semantique : variable %s non declaree ==> L%d\n", $8, nb_ligne);}
			 if (strcmp((char*)$4, (char*)signeFormatage(getType($8))) != 0)
			{ printf("Erreur semantique : Non compatibilite de SF ==> L%d\n",nb_ligne);}}
;
ECRITURE: mc_write par_ouv chaine sep LISTE_IDF_OUT par_frm dlr
			{
			 if(NbIDF!=nbSigne($3)) 
        {printf("Erreur semantique: nombre de parametres incorrecte dans la ligne : %d (Nb signe formattage = %d, Nb parametre =%d )\n",nb_ligne,nbSigne($3),NbIDF);}
			else {
			int i;
			for (i=0; i< NbIDF; i++){
			if (Declaration(tabIDF[i])== 0){ TableauSigne($3, tabSigne);
			if(strcmp((char*)tabSigne[i], (char*)signeFormatage(tabIDF[i]))!=0) {
			printf("\n erreur semantique: signe de formatage non compatibe a la ligne : %d\n",nb_ligne);}
			}
			}
			}
			}
;
LISTE_IDF_OUT: idf separateur LISTE_IDF_OUT { NbIDF++; tabIDF[NbIDF-1]= $1;}
				| idf { NbIDF++; tabIDF[NbIDF-1]= $1;}
;
TYPE: mc_integer { strcpy(sauvType,$1) ; }
	  | mc_char { strcpy(sauvType,$1) ; }
	  | mc_string { strcpy(sauvType,$1) ; }
	  | mc_real { strcpy(sauvType,$1) ; }
;
SIGNE_DE_FORMATAGE: pvg
					|sfc
					|sfr
					|sfs
;
BLOC_INST: AFFECTATION BLOC_INST
			|
;
LISTE_BIB: BIB LISTE_BIB
			|
;
BIB: include NOM_BIB 
;
NOM_BIB: bib_array {Bib[1] = 1;}
		| bib_loop {Bib[2] = 1;}
		| bib_proc {Bib[0] = 1;}
;



%%
main()
{ initialisation();
  afficher();
  yyparse();
  afficher();
}
yywrap() {}
yyaccept(){}
yyerror(char * msg) {printf("erreur syntaxique a la ligne %d.\n ",nb_ligne);}
