/*BENABED ANFEL 171731030391*/
/*BOUACHAT ANFEL 181831041144*/
/****************CREATION DE LA TABLE DES SYMBOLES ******************/
/***Step 1: Definition des structures de données ***/
#include <stdio.h>
#include <stdlib.h>

typedef struct
{
   int state;
   char name[20];
   char code[20];
   char type[20];
   float val;
 } element;

typedef struct
{ 
   int state; 
   char name[20];
   char type[20];
} elt;

element tab[1000];
elt tabs[40],tabm[40];
extern char sav[20];

/***Step 2: initialisation de l'état des cases des tables des symbloles***/
/*0: la case est libre    1: la case est occupée*/

void initialisation()
{
  int i;
  for (i=0;i<1000;i++)
    tab[i].state=0;

  for (i=0;i<40;i++)
    {tabs[i].state=0;
    tabm[i].state=0;}

}


/***Step 3: insertion des entititées lexicales dans les tables des symboles ***/

void inserer (char entite[], char code[],char type[],float val,int i,int y)
{
  switch (y)
 { 
   case 0:/*insertion dans la table des IDF et CONST*/
       tab[i].state=1;
       strcpy(tab[i].name,entite);
       strcpy(tab[i].code,code);
	   strcpy(tab[i].type,type);
	   tab[i].val=val;
	   printf (" la valeur de l'entiteeeeeee lexicale est %f \n", val );
	   break;

   case 1:/*insertion dans la table des mots clés*/
       tabm[i].state=1;
       strcpy(tabm[i].name,entite);
       strcpy(tabm[i].type,code);
       break; 
    
   case 2:/*insertion dans la table des séparateurs*/
      tabs[i].state=1;
      strcpy(tabs[i].name,entite);
      strcpy(tabs[i].type,code);
      break;
 }

}

/***Step 4: La fonction Rechercher permet de verifier  si l'entité existe dèja dans la table des symboles */
void rechercher (char entite[], char code[],char type[],float val,int y)	
{

int j,i;

switch(y) 
  {
   case 0:/*verifier si la case dans la tables des IDF et CONST est libre*/
        for (i=0;((i<1000)&&(tab[i].state==1))&&(strcmp(entite,tab[i].name)!=0);i++); 
        if(i<1000)
        { 
	        
			inserer(entite,code,type,val,i,0); 
	      
         }
        else
          printf("entité existe déjà\n");
        break;

   case 1:/*verifier si la case dans la tables des mots clés est libre*/
       
       for (i=0;((i<40)&&(tabm[i].state==1))&&(strcmp(entite,tabm[i].name)!=0);i++); 
        if(i<40)
          inserer(entite,code,type,val,i,1);
        else
          printf("entité existe déjà\n");
        break; 
    
   case 2:/*verifier si la case dans la tables des séparateurs est libre*/
         for (i=0;((i<40)&&(tabs[i].state==1))&&(strcmp(entite,tabs[i].name)!=0);i++); 
        if(i<40)
         inserer(entite,code,type,val,i,2);
        else
   	       printf("entité existe déjà\n");
        break;

    case 3:/*verifier si la case dans la tables des IDF et CONST est libre*/
        for (i=0;((i<1000)&&(tab[i].state==1))&&(strcmp(entite,tab[i].name)!=0);i++); 
                  
        if (i<1000)
        { inserer(entite,code,type,val,i,0); }
        else
          printf("entité existe déjà\n");
        break;
  }

}


/***Step 5 L'affichage du contenue de la table des symboles ***/

void afficher()
{int i;

printf("/***************Table des symboles IDF*************/\n");
printf("\n/***************Table des symboles ******************/\n");
printf("____________________________________________________________________\n");
printf("\t| Nom_Entite |  Code_Entite | Type_Entite | Val_Entite\n");
printf("____________________________________________________________________\n");
  
for(i=0;i<20;i++)
{	
	
    if(tab[i].state==1)
      { 
        printf("\t|%10s |%15s | %12s | %12f\n",tab[i].name,tab[i].code,tab[i].type,tab[i].val);
         
      }
}
printf("\n/***************Table des symboles mots clés*************/\n");

printf("_____________________________________\n");
printf("\t| NomEntite |  CodeEntite | \n");
printf("_____________________________________\n");
  
for(i=0;i<40;i++)
    if(tabm[i].state==1)
      { 
        printf("\t|%10s |%12s | \n",tabm[i].name, tabm[i].type);
               
      }

printf("\n/***************Table des symboles séparateurs*************/\n");

printf("_____________________________________\n");
printf("\t| NomEntite |  CodeEntite | \n");
printf("_____________________________________\n");
  
for(i=0;i<40;i++)
    if(tabs[i].state==1)
      { 
        printf("\t|%10s |%12s | \n",tabs[i].name,tabs[i].type );
        
      }

}

int search_pos(char entite []){
	int i = 0;
	while(i<100){
		if (strcmp(entite , tab[i].name) == 0) return i;
		i++;
	}
	return -1;
}
int DoubleDec (char entite[]){
	int j = search_pos(entite);
	if (j != -1) {if (strcmp(tab[j].type, " ") == 0) return 0;}
	return -1;
}
 void insererTYPE(char entite[], char type[])
	{
       int pos;
	   pos=search_pos(entite);
	   if(pos!=-1)  { strcpy(tab[pos].type,type); }
	}
int Declaration (char entite[]){
	int j = search_pos(entite);
	if (j != -1) {if (strcmp(tab[j].type, " ") == 0) return 0;}
	return -1;
}
char* getType(char nom[])
{    
    char* str =tab[search_pos(nom)].type;
    return (char*)str;
}
char signeFormatage (char type[]){
	if (type == "entier") return ';' ;
	if (type == "reel") return '%' ;
	if (type == "string") return '?' ;
	if (type == "char") return '&' ;
}
int nbSigne(char chaine[]){
	int i, nb =0;
	for(i=0; i< strlen(chaine); i++){
		if(chaine[i] == '%' || chaine[i] == ';' || chaine[i] == '$') { nb++;}
	}
	return nb;
}
void TableauSigne(char chaine[], char tableau[20]){
	int i, nb =0;
	for(i=0; i< strlen(chaine); i++){
		if(chaine[i] == '%' || chaine[i] == ';' || chaine[i] == '$') { nb++; tableau[nb-1]= chaine[i];}
	}
}

