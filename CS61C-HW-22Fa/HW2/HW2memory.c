#include <stdio.h>
#include <stdbool.h>
#include <stdlib.h>

typedef struct tree {
  struct tree* left;
  union 
  {
    struct tree* right;
    int data;
  } rd;
} Inttree;

Inttree* lefttree(Inttree* t)
{
	return t->left;
}

Inttree* righttree(Inttree* t)
{
	return t->left ? t->rd.right : NULL;
}

bool isleaf(Inttree* t)
{
	return !(t->left);
}

void printtree(Inttree* t)
{
  if(t == NULL) return;
  if(isleaf(t)) printf("%d ", t->rd.data);
  else 
  {
      printtree(lefttree(t));
	  printtree(righttree(t));
  }
}

void freetree(Inttree* t)
{
	if(t == NULL) return;
	if(!isleaf(t))
	{
		freetree(lefttree(t));
		freetree(righttree(t));
	}
	free(t);
}

Inttree* maketree(Inttree* left, Inttree* right)
{
	Inttree* t = malloc(sizeof(Inttree));
	t->left = left;
	t->rd.right = right;
	return t;
}

Inttree* makeleaf(int val)
{
	Inttree* t = malloc(sizeof(Inttree));
	t->left = NULL;
	t->rd.data = val;
	return t;
}

void q1()
{
	char str[]  = {65, 83, 67, 73, 73, 32, 105, 115, 32, 102, 117, 110, 0};
	Inttree root;
	root.left = maketree(makeleaf(3), maketree(makeleaf(1), makeleaf(4)));
	root.rd.right = maketree(maketree(makeleaf(1), makeleaf(5)), maketree(makeleaf(9), makeleaf(3)));
	printf("%s\n", &(str[0]));
	printtree(&root);
	printf("\n");
	freetree(root.left);
	freetree(root.rd.right);
}
static Inttree* initializetree() {
	return NULL;//CODE OMITTED;
}
void q2()
{
	int a1 = 0xDEADBEEF;
	char str[20];
	int a2 = 0xABACABAC;
	Inttree* tree = initializetree(); //Code omitted
	//Breakpoint 1
	printf("%s\n", &(str[0]));
	printtree(tree);
	printf("\n");
}



int main(int argc, char** argv)
{
	q1();
	q2();
}