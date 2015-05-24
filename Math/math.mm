//
//  math.c
//  Math
//
//  Created by pc on 14-11-26.
//  Copyright (c) 2014年 pc. All rights reserved.
//

#include "math.h"

// test5.cpp : 定义控制台应用程序的入口点。
//

#include "stdafx.h"

// 全排列.cpp : 定义控制台应用程序的入口点。
//

#include "stdafx.h"
#include "iostream.h"
#include <time.h>
using namespace std;
void Print(int a[], int n);
void Permutation1(int n);
void Permutation2(int n);
void Permutation3(int n);
void Permutation4(int n);

bool Move(int a[], bool p[], int n);
inline void Print(int a[],int n)                           //排列输出和计数
{
    int i;
    for(i=0;i<n;i++)
        printf("%d", a[i]);
    printf("  ");
    if(i%4==0)
        printf("         ");
}




int main()
{
    int n=0;
    cout<< "请输入全排列位数：n"<<'\n'<<endl;
    cin>>n;
    
    double start, finish;
    start=clock();
    Permutation1(n);
    finish=clock();
    printf( "%f ms\n",(finish - start) *1000/ CLOCKS_PER_SEC);
    start=clock();
    Permutation2(n);
    finish=clock();
    
    printf( "%f ms\n",(finish - start) *1000/ CLOCKS_PER_SEC);
    
    start=clock();
    Permutation3(n);
    finish=clock();
    printf( "%f ms\n",(finish - start) *1000/ CLOCKS_PER_SEC);
    
    start=clock();
    Permutation4(n);
    finish=clock();
    printf( "%f ms\n",(finish - start) *1000/ CLOCKS_PER_SEC);
    
    
    system("pause");
}


/////////////////////////排列邻位对换法////////////////////////////////
void Permutation1(int n)
{
    int  *a = new int[n];  //用来存储n个自然数
    bool *p = new bool[n]; //用来存储n个元素的指向：向左为false，向右为true
    for (int i=0; i<n; i++) //存储全排列的元素值，并计算全排列的数量
    {
        a[i] = i + 1;
        p[i] = false; //开始均指向左侧
    }
    
    do
    {
        Print(a, n); //输出第一个全排列
        if (n == a[n-1])//若n在最右侧，将其逐次与左侧的元素交换，得到n - 1个新的排列
        {
            for (int i=n-1; i>0; i--)
            {
                int  temp = a[i]; a[i] = a[i-1]; a[i-1] = temp;
                bool flag = p[i]; p[i] = p[i-1]; p[i-1] = flag;
                Print(a, n);
            }
        }
        else //若n在最左侧，将其逐次与右侧的元素交换，得到n - 1个新的排列
        {
            for (int i=1; i<n; i++)
            {
                int temp = a[i]; a[i] = a[i-1]; a[i-1] = temp;
                bool flag = p[i]; p[i] = p[i-1]; p[i-1] = flag;
                Print(a, n);
                
            }
        }
    } while (Move(a, p, n));
    //Print(a, n) ; //输出最后一个全排列
    
    delete []a;
    delete []p;
}

/*
 函数名称：Move
 函数功能：寻找最大可移数，可移数m，将m与其箭头所指的邻数互换位置，
 并将所得新排列中所有比m大的数p的方向调整
 输入变量：int a[]：存储了1，2，3，...，n共n个自然数的数组
 bool p[]：存储了n个元素的指向的数组：向左为false，向右为true
 int n：数组a[]的长度
 输出变量：排列中存在最大可移数，则做了相关操作后返回真，否则直接返回假
 */
bool Move(int a[], bool p[], int n)
{
    int max = 1;
    int pos = -1;
    
    for (int i=0; i<n; i++)
    {
        if (a[i] < max)
            continue;
        if ((p[i] && i < n-1 && a[i] > a[i+1]) || //指向右侧
            (!p[i] && i > 0 && a[i] > a[i-1]))    //指向左侧
        {
            max = a[i];
            pos = i;
        }
    }
    
    if (pos == -1) //都不能移动
        return false;
    
    //与其箭头所指的邻数互换位置
    if (p[pos]) //指向右侧
    {
        int  temp = a[pos]; a[pos] = a[pos+1]; a[pos+1] = temp;
        bool flag = p[pos]; p[pos] = p[pos+1]; p[pos+1] = flag;
    }
    else //指向左侧
    {
        int  temp = a[pos]; a[pos] = a[pos-1]; a[pos-1] = temp;
        bool flag = p[pos]; p[pos] = p[pos-1]; p[pos-1] = flag;
    }
    
    //将所得排列中所有比max大的数p的方向调整
    for (int i=0; i<n; i++)
    {
        if (a[i] > max)
            p[i] = !p[i];
    }
    
    return true;
}

//////////////////////////////递增进位排列生成算法////////////////////////
/*
 函数名称：Permutation
 函数功能：递增进位排列生成算法：输出n个数的所有全排列
 输入变量：int n：1，2，3，...，n共n个自然数
 输出变量：无
 */
void Permutation2(int n)
{
    int M=1;
    for (int i=1; i<=n; i++)
    {
        M =i*M;
    }
    int *b = new int[n];      //用来存储新的全排列
    int *yShe = new int[n-1]; //将原中介数加上序号i的递增进位制数得到新的映射
    for (int i=0; i<n-1; i++)
    {
        yShe[i] = 0;
    }
    int m=0;
    for (int l=0; l<M; l++)
    {
        //每次递增1后得到得到新的映射
        for(int i=2,k=m;i<=n;i++)
        {
            yShe[i-2]=k%i;
            k=k/i;
        }
        m=m+1;
        //cout<<m<<endl;
        //Print(yShe,n-1);
        for (int i=0; i<n; i++) //新的全排列空格初始化
            b[i] = 0;
        
        int num=n;
        //获取前n-1个数字
        for(int j=n-2;j>=0;j--)
        {
            int p=0;
            for(int i=n-1;i>=0;i--)
            {
                if(b[i]==0)
                {
                    if(p==yShe[j]){b[i]=num;break;}
                    p++;
                }
                
            }
            num--;
            
        }
        for(int i=0;i<n;i++)
        {if(b[i]==0)b[i]=1;}
        
        
        //填充最后一个数字1
        
        
        Print(b,n);
    }
    
    //  Print(b, n); //输出最后一个全排列
    
    delete []b;
    delete []yShe;
}
void Permutation3(int n)
{
    int M=1;
    for (int i=1; i<=n; i++)
    {
        M =i*M;
    }
    int *b = new int[n];      //用来存储新的全排列
    int *yShe = new int[n-1]; //将原中介数加上序号i的递增进位制数得到新的映射
    for (int i=0; i<n-1; i++)
    {
        yShe[i] = 0;
    }
    int m=0;
    for (int l=0; l<M; l++)
    {
        //每次递增1后得到得到新的映射
        for(int i=n,k=m;i>1;i--)
        {
            yShe[n-i]=k%i;
            k=k/i;
        }
        m=m+1;
        //cout<<m<<endl;
        // Print(yShe,n-1);
        for (int i=0; i<n; i++) //新的全排列空格初始化
            b[i] = 0;
        
        int num=n;
        //获取前n-1个数字
        for(int j=0;j<n-1;j++)
        {
            int p=0;
            for(int i=n-1;i>=0;i--)
            {
                if(b[i]==0)
                {
                    if(p==yShe[j]){b[i]=num;break;}
                    p++;
                }
                
            }
            num--;
            
        }
        for(int i=0;i<n;i++)
        {if(b[i]==0)b[i]=1;}
        
        
        //填充最后一个数字1
        
        
        Print(b, n);
        
    }
    
    //  Print(b, n); //输出最后一个全排列
    
    delete []b;
    delete []yShe;
}



void Permutation4(int n)
{
   	int *b = new int[n];      //用来存储新的全排列
    for(int i=0;i<n;i++)
    {  b[i]=i+1;}
    Print(b,n);
    int i=0,j=0,p=0,q=0,m=0,s=0;
    int    temp=0;
    while(1)
    {
        for(i=n-2;i>=0;i--)
        {
            
            if(b[i]<b[i+1])m=i;
            
            
            if(b[i]<b[i+1]) break;
        }
        if(i==-1)break;
        for(j=n-1;j>i;j--)
        {
            
            if(b[i]<b[j]) s=j;
            
            if(b[i]<b[j]) break;
        }
        temp=b[s];b[s]=b[m];b[m]=temp;
        
        for(p=i+1,q=n-1;p<q;p++,q--)
        {
            temp= b[p];b[p]=b[q];b[q]=temp;
            
        }
        Print(b,n);
        printf("       ");
    }
}
