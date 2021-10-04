/* Comments for no Reason */
// This is a comment too
#include<stdio.h>  
// Comments everywhere
int main()    
{    
    int n,r,sum=0,temp; 
    float f=+12.890e-90;   
    printf("Enter the Number:\n");    
    scanf("%d",&n);    
    temp=n;    
    while(temp>0)    
    {    
        r=temp%10;    
        sum=(sum*10)+r;    
        temp/=10;    
    }    
    if(n==sum)    
        printf("Palindrome Number");    
    else    
        printf("Not Palindrome");   
    return 0;  
}