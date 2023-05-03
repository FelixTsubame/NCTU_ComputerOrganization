// Author:0716049 ,0716009

#include <iostream>
#include <fstream>
#include <stdio.h>
#include <math.h>
#include <vector>

using namespace std;

vector<unsigned int> acc;
int ans1,ans2,ans3;

struct cache_content
{
	bool v;
	unsigned int tag;
    // unsigned int	data[16];
};

const int K = 1024;

int log2(int n1)
{  
    // log(n) / log(2) is log2.
    //return log(n) / log(double(2));
	int m=0;
	while(n1>1){
		m++;
		n1/=2;
	}
	return m;
}


void simulate(int cache_size, int block_size, int m)
{
	unsigned int tag, index, x;
    int i,j,k;
    int m1=(int)log2(m);
	int offset_bit = (int)log2(block_size);
	int index_bit = (int)log2(cache_size / block_size);
	int line = cache_size >> (offset_bit);
    int sum=0;
    line/=m;
    vector<cache_content> a[line];
	
    //cout << "cache line: " << line << endl;
    //FILE *fp = fopen("LU.txt", "r");  // read file
	double miss=0,accesses=0;
    for(k=0;k<acc.size();k++){
        x=acc[k];
		index = x >> offset_bit;
		tag = x >> (index_bit + offset_bit - m1);
        bool ch=false;
        for(i=0;i<a[index%line].size();i++){
            if(a[index%line][i].tag==tag&&a[index%line][i].v){    //hit
                cache_content ne1;
                ne1=a[index%line][i];
                accesses++;
                ch=true;
                for(j=i;j<a[index%line].size()-1;j++){
                    a[index%line][j]=a[index%line][j+1];
                }
                a[index%line][j]=ne1;

                break;
            }
        }
        if(ch==false){                  //miss
            accesses++;
            miss++;
            cache_content ne;
            ne.tag=tag;
            ne.v=true;
            if(a[index%line].size()<m){
                a[index%line].push_back(ne);
            }
            else if(a[index%line].size()==m){                       //LRU
                a[index%line].erase(a[index%line].begin());
                a[index%line].push_back(ne);
            }

        }
	}
	//fclose(fp);
	//cout << miss/accesses << endl;
    ans1=(accesses-miss)*4+miss*(1+8*(1+100+1+2)+2+1);
    ans2=(accesses-miss)*4+miss*(1+(1+100+1+2)+2+1);
}

void simulate1(int cache_size, int block_size, int m)
{
	unsigned int tag, index, x;
    int i,j,k,ii,jj;
    int m1=(int)log2(m);
	
    int offset_bit = (int)log2(block_size);
	int index_bit = (int)log2(cache_size / block_size);
	int line = cache_size >> (offset_bit);
    line/=m;
    vector<cache_content> a[line];

    unsigned int tag1, index1;
    int cache_size1=4*K;
    int block_size1=32*4;
    int offset_bit1 = (int)log2(block_size1);
	int index_bit1 = (int)log2(cache_size1 / block_size1);
    int line1 = cache_size1 >> (offset_bit1);
    line1/=m;
    vector<cache_content> a1[line1];
	double accesses=0,miss=0;
    double access_l2=0,miss_l2=0;
    int sum=0;
	for(k=0;k<acc.size();k++){
        x=acc[k];
		index = x >> offset_bit;
		tag = x >> (index_bit + offset_bit - m1);
        
        index1 = x >> offset_bit1;
		tag1 = x >> (index_bit1 + offset_bit1 - m1);
        
        bool ch=false;
        bool ch1=false;
        for(i=0;i<a[index%line].size();i++){
            if(a[index%line][i].tag==tag&&a[index%line][i].v){    //L1 hit
                cache_content ne1;
                ne1=a[index%line][i];
                accesses++;
                sum+=3;
                ch=true;
                for(j=i;j<a[index%line].size()-1;j++){
                    a[index%line][j]=a[index%line][j+1];
                }
                a[index%line][j]=ne1;
                break;
            }
        }
        if(ch==false){                  //L1 miss
            cache_content ne;
            ne.tag=tag;
            ne.v=true;
            miss++;
            if(a[index%line].size()<m){
                a[index%line].push_back(ne);
            }
            else if(a[index%line].size()==m){                       //LRU
                a[index%line].erase(a[index%line].begin());
                a[index%line].push_back(ne);
            }

            for(ii=0;ii<a1[index1%line1].size();ii++){
                if(a1[index1%line1][ii].tag==tag1&&a1[index1%line1][ii].v){    //L2 hit
                    cache_content ne2;
                    ne2=a1[index1%line1][ii];
                    access_l2++;
                    sum+=(1+4*(1+10+1+1)+1+1);
                    ch1=true;
                    for(jj=ii;jj<a1[index1%line1].size()-1;jj++){
                        a1[index1%line1][jj]=a1[index1%line1][jj+1];
                    }
                    a1[index1%line1][jj]=ne2;
                    break;
                }
            }
            if(ch1==false){                  //L2 miss
                cache_content ne3;
                ne3.tag=tag1;
                ne3.v=true;
                miss_l2++;
                if(a1[index1%line1].size()<m){
                    a1[index1%line1].push_back(ne3);
                }
                else if(a1[index1%line1].size()==m){                       //LRU
                    a1[index1%line1].erase(a1[index1%line1].begin());
                    a1[index1%line1].push_back(ne3);
                }
                sum+=(1+32*(1+100+1+10)+4*(1+10+1+1)+1+1);
            }

        }
	}
    ans3=sum;
}


int main(int argc, char *argv[]){
    string s;
    s=argv[1];
    FILE *fp = fopen(s.c_str(), "r");
    unsigned int x1,x2,x3;
    int m,n,p;
    fscanf(fp,"%x%x%x",&x1,&x2,&x3);
    fscanf(fp,"%d%d%d",&m,&n,&p);
    int a[m][n],b[n][p];
    int i,j;
    for(i=0;i<m;i++){
        for(j=0;j<n;j++){
            fscanf(fp,"%d",&a[i][j]);
        }
    }
    for(i=0;i<n;i++){
        for(j=0;j<p;j++){
            fscanf(fp,"%d",&b[i][j]);
        }
    }
    int c[m][p];
    int k;
    for(i=0;i<m;i++){
        for(j=0;j<p;j++){
            c[i][j]=0;
        }
    }
    for(i=0;i<m;i++){
        for(j=0;j<p;j++){
            for(k=0;k<n;k++){
                c[i][j]+=a[i][k]*b[k][j];
                acc.push_back((unsigned int)4*(i*p+j)+x3);
                acc.push_back((unsigned int)4*(i*n+k)+x1);
                acc.push_back((unsigned int)4*(k*p+j)+x2);
                acc.push_back((unsigned int)4*(i*p+j)+x3);
            }
        }
    }
    ofstream file (argv[2]);
    for(i=0;i<m;i++){
        for(j=0;j<p;j++){
            file << c[i][j] << " ";
        }
        file << endl;
    }
    simulate(512,32,8);
    simulate1(128,16,8);
    file << 2+m*(5+(p*(5+(n*22+2))+2))+2+1 << " " << ans1 << " " << ans2 << " " << ans3 << endl;
    return 0;
}