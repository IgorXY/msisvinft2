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
		}
		if ((*code)[i]=='"')
		{
			i++;
			(*code)[i]=' ';
			while((i<length)&&((*code)[i]!='"'))
			{
				(*code)[i]=' ';
				i++;
			}
		}
	}
}



void Metric(char **code, int length, int *if_count, int *max_deep, int *operator_count)
{
	int i, curent_deep=0, begin_count=0,  case_count=0;
	char s_begin[5]={'b', 'e', 'g', 'i', 'n'};
	char s_case[4]={'c', 'a', 's', 'e'};
	char s_end[3]={'e', 'n', 'd'};
	char s_if[2]={'i', 'f'};
	*if_count=0;
	*max_deep=0;
	*operator_count=0;
	for (i=0; i<length; i++)
	{
		if(((*code)[i]>='A')&&((*code)[i]<='Z'))
			(*code)[i]=(*code)[i]+('a'-'A');
	}

	for (i=0; i<length; i++)
	{
			switch ((*code)[i])
		{
			case 'i':
				{
					if ((*code)[i+1]==s_if[1])
						i+=sizeof(s_if)/sizeof(char)-1;
					else
						(*code)[i]=' ';
					break;
				}
			case 'b':
				{
					if (((*code)[i+1]==s_begin[1])&&((*code)[i+2]==s_begin[2])&&((*code)[i+3]==s_begin[3])&&((*code)[i+4]==s_begin[4]))
					{
						i+=sizeof(s_begin)/sizeof(char)-1;
						if (case_count>0)
							case_count++;
					}
					else
						(*code)[i]=' ';
					break;
				}
			case 'e':
				{
					if (((*code)[i+1]==s_end[1])&&((*code)[i+2]==s_end[2]))
					{
						i+=sizeof(s_end)/sizeof(char)-1;
						if (case_count>0)
							case_count--;
					}
					else
						(*code)[i]=' ';
					break;
				}
			case 'c':
				{
					if (((*code)[i+1]==s_case[1])&&((*code)[i+2]==s_case[2])&&((*code)[i+3]==s_case[3]))
					{
						case_count++;
					}
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
		while(((*code)[i]!='i')&&(i<length))
			i++;
		if  ((*code)[i+1]==s_if[1])
		{
			(*if_count)++;
			i+=2;
			curent_deep++;
			do
			{
			switch ((*code)[i])
			{
			case 'i':
				{
					(*if_count)++;
					curent_deep++;
					i+=sizeof(s_if)/sizeof(char);
					break;
				}
			case 'b':
				{
					i+=sizeof(s_begin)/sizeof(char);
					begin_count=1;
					break;
				}
			case 'e':
				{
					i+=sizeof(s_end)/sizeof(char);
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
	//		printf("%s", code);
		float relative_if_count;
		if ((operators_count)&&(if_count))
			relative_if_count= float(if_count)/(float(operators_count));
		else
			relative_if_count=0;
		printf("\nIf count:%d\nMax if deep: %d\nRelative amount: %lf", if_count, max_deep, relative_if_count);
	}	
	getch();
}
