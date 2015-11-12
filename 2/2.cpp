#include <stdio.h>
#include <conio.h>
#include <stdlib.h>
#include <string.h>

void DeleteComments(char **code, int length)
{
	for (int i=0; i<length-1; i++)
	{
		if (((*code)[i]=='/')&&((*code)[i+1]=='/')) 
			while((i<length)&&((*code)[i]!='\n'))
			{
				(*code)[i]=' ';
				i++;
			}
		if ((*code)[i]=='{')
		{
			while((i<length)&&((*code)[i]!='}'))
			{
				(*code)[i]=' ';
				i++;
			}
			if (i<length)
				(*code)[i]=' ';
		}
	}
}

bool CheckIF(char *code, int i)
{
	if (((code[i-1]=='i')||(code[i-1]=='I'))&&((code[i]=='f')||(code[i]=='F')))
		return true;
	else
		return false;
}

void Metric(char **code, int length, int *if_count, int *max_deep, int *operator_count)
{
	int i, curent_deep=0, begin_count=0,  case_count=0;
	*if_count=0;
	*max_deep=0;
	*operator_count=0;
	for (i=0; i<length; i++)
	{
			switch ((*code)[i])
		{
			case 'i':
			case 'I':
				{
					if ((*code)[i+1]=='f')
						i+=2;
					else
						(*code)[i]=' ';
					break;
				}
			case 'b':
			case 'B':
				{
					if (((*code)[i+1]=='e')&&((*code)[i+2]=='g')&&((*code)[i+3]=='i')&&((*code)[i+4]=='n'))
					{
						i+=5;
						if (case_count>0)
							case_count++;
					}
					else
						(*code)[i]=' ';
					break;
				}
			case 'e':
			case 'E':
				{
					if (((*code)[i+1]=='n')&&((*code)[i+2]=='d'))
					{
						i+=3;
						if (case_count>0)
							case_count--;
					}
					else
						(*code)[i]=' ';
					break;
				}
			case 'c':
			case 'C':
				{
					if (((*code)[i+1]=='a')&&((*code)[i+2]=='s')&&((*code)[i+3]=='e'))
					{
						i+=4;
						case_count++;
					}
					else
						(*code)[i]=' ';
					break;
				}
			case ':':
				{
					if (case_count>0)
					{
						if ((*code)[i+1]==' ')
						{
							(*code)[i-1]='i';
							(*code)[i]='f';
							i+=1;
						}
					}
					else
						(*code)[i]=' ';
					break;
				}

			case '\n':
				{
					break;
				}
			case ';':
				{
					(*operator_count)++;
					break;
				}
			default:
				(*code)[i]=' ';

		}
	}
	i=0;
	while(i<length)
	{
		while((((*code)[i]!='i')&&((*code)[i]!='I'))&&(i<length))
			i++;
		if  ((*code)[i+1]=='f')
		{
			(*if_count)++;
			i+=2;
			curent_deep++;
			do
			{
			switch ((*code)[i])
			{
			case 'i':
			case 'I':
				{
					(*if_count)++;
					curent_deep++;
					i+=2;
					break;
				}
			case 'b':
			case 'B':
				{
					i+=5;
					begin_count++;
					break;
				}
			case 'e':
			case 'E':
				{
					i+=3;
					begin_count--;
					break;
				}
			case ';':
				{
					i++;
					if (begin_count==0)
						begin_count--;
					break;
				}
			default:
				i++;
			}
			}while(begin_count>=0);
			if (curent_deep>*max_deep)
				(*max_deep)=curent_deep;
			curent_deep=0;
			begin_count=0;
		}
		else
			i++;

		}
	(*operator_count)+=(*if_count);
}

void main()
{
	FILE *input_file;
	char file_name[30];
	printf("Enter file name: ");
	scanf("%s", file_name);
	input_file=fopen(file_name, "r");
	if (!input_file)
		printf("File doesn't exist!");
	else
	{
		char *code=NULL, scan_char;
		int code_length=0, if_count=0, max_deep=0, operators_count=0;
		while (!feof(input_file))
		{
			fscanf(input_file, "%c", &scan_char);
			code_length++;
			code=(char *)realloc(code, code_length*sizeof(char));
			code[code_length-1]=scan_char;
		}
		DeleteComments(&code, code_length);
		Metric(&code, code_length, &if_count, &max_deep, &operators_count);
	//	printf("%s", code);
	//	if_count=CountIF(code, code_length, 0, 0);
		float relarive_if_count;
		relarive_if_count= float(if_count)/(float(operators_count));
		printf("\nIf count:%d\nMax if deep: %d\nRelative amount: %lf", if_count, max_deep, relarive_if_count);
	}
	getch();
}
