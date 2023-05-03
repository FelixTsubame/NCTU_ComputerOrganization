// Author:0710028 ,0710001

#include <iostream>
#include <stdio.h>
#include <math.h>
#include <string>
#include <vector>
#include <fstream>

using namespace std;

const int K = 1024;

vector<unsigned int> addr;

int tmsc1,tmsc2,tmsc3;

struct cache_content
{
	bool v;
	unsigned int tag;
    // unsigned int	data[16];
};

double log2(double n)
{
    // log(n) / log(2) is log2.
    return log(n) / log(double(2));
};

void simulate(int cache_size, int n_ways)
{
	unsigned int tag, index, x, index_pre;
    int block_size = 8*4;
	int offset_bit = (int)log2(block_size);
	int line = (cache_size >> (offset_bit));
	int index_bit = (int)log2(cache_size / block_size);
	int set_n = (int)log2(n_ways);
	int access = 0;
	int miss = 0;
    line /= n_ways;
	//cache_content *cache = new cache_content[line];
    vector<cache_content> cache[line];

    //cout << "cache line: " << line << endl;

    //FILE *fp = fopen("RADIX.txt", "r");  // read file

    for(int i=0;i<addr.size();i++)
    {
        //cout << access << " ";
		access++;
		//cout << hex << x << " ";
		x = addr[i];
		index = (x >> offset_bit) % line;
		tag = x >> (index_bit + offset_bit - set_n);

        /*if(cache[index].used_t==0)
        {
            cache[index].tag.insert(cache[index].tag.end(),tag);
            cache[index].used_t++;
            miss++;
        }*/
        cache_content new_in;
        new_in.tag = tag;
        new_in.v = true;
            bool hit=false;//key_hit
            for(int i=0;i<cache[index].size();i++)
            {
                if(cache[index][i].tag==tag&&cache[index][i].v)
                {
                    cache[index].erase(cache[index].begin()+i);
                    cache[index].insert(cache[index].begin(),new_in);
                    hit = true;

                    //cout <<"yes\n" << index << " " << tag << "\n";
                    break;
                }
            }
            if(!hit)
            {
                if(cache[index].size()<n_ways)
                {
                    cache[index].insert(cache[index].begin(),new_in);
                    miss++;
                    //cout << "rrrrr\n" << index << " " << tag <<"\n";
                }
                else
                {
                    cache[index].pop_back();
                    cache[index].insert(cache[index].begin(),new_in);
                    miss++;
                    //cout << "QQQQ\n" << index << " " << tag << "\n";
                }
            }

	}

	//cout << "\n";
	//cout << "Miss rate = " << (double)miss/access*100 << "%\n";
    /*for(int j = 0; j < line/n_ways; j++)
		for(int i = 0; i < cache[index].tag.size(); i++)
            cout << cache[index].tag[i] << " ";
    */
    tmsc1 = (1+2+1)*(access-miss)+miss*(1+8*(1+100+1+2)+2+1);
    tmsc2 = (1+2+1)*(access-miss)+miss*(1+(1+100+2+1)+2+1);

	for(int i=0;i<line;i++)
        cache[i].clear();

	//fclose(fp);

}

void simulate_2level(int cache_size1, int cache_size2, int n_ways)
{
	unsigned int tag1, tag2, index1, index2, x;
    int block_size1 = 4*4, block_size2 = 32*4;

	int offset_bit_1 = (int)log2(block_size1);
	int offset_bit_2 = (int)log2(block_size2);

	int line1 = (cache_size1 >> (offset_bit_1));
	int line2 = (cache_size2 >> (offset_bit_2));

	int index_bit1 = (int)log2(cache_size1 / block_size1);
	int index_bit2 = (int)log2(cache_size2 / block_size2);

	int set_n = (int)log2(n_ways);
	int access = 0, access_1_2 = 0;
	int miss = 0, miss_2 = 0;
    line1 /= n_ways;
    line2 /= n_ways;
	//cache_content *cache = new cache_content[line];
    vector<cache_content> cache1[line1];
    vector<cache_content> cache2[line2];

    //cout << "cache line: " << line << endl;

    //FILE *fp = fopen("RADIX.txt", "r");  // read file

    for(int i=0;i<addr.size();i++)
    {
        //cout << access << " ";
		access++;
		//cout << hex << x << " ";
		x = addr[i];
		index1 = (x >> offset_bit_1) % line1;
		tag1 = x >> (index_bit1 + offset_bit_1 - set_n);

        /*if(cache[index].used_t==0)
        {
            cache[index].tag.insert(cache[index].tag.end(),tag);
            cache[index].used_t++;
            miss++;
        }*/
        cache_content new_in;
        new_in.tag = tag1;
        new_in.v = true;
            bool hit1=false;//key_hit
            for(int i=0;i<cache1[index1].size();i++)
            {
                if(cache1[index1][i].tag==tag1&&cache1[index1][i].v)
                {
                    cache1[index1].erase(cache1[index1].begin()+i);
                    cache1[index1].insert(cache1[index1].begin(),new_in);
                    hit1 = true;

                    //cout <<"yes\n" << index << " " << tag << "\n";
                    break;
                }
            }
            if(!hit1)
            {
                if(cache1[index1].size()<n_ways)
                {
                    cache1[index1].insert(cache1[index1].begin(),new_in);
                    //miss++;
                    //cout << "rrrrr\n" << index << " " << tag <<"\n";
                }
                else
                {
                    cache1[index1].pop_back();
                    cache1[index1].insert(cache1[index1].begin(),new_in);
                    //miss++;
                    //cout << "QQQQ\n" << index << " " << tag << "\n";
                }
                miss++;
                access_1_2++;
                bool hit2=false;
                cache_content new_in2;
                index2 = (x >> offset_bit_2) % line2;
                tag2 = x >> (index_bit2 + offset_bit_2 - set_n);
                new_in2.tag = tag2;
                new_in2.v = true;
                for(int i=0;i<cache2[index2].size();i++)
                {
                    if(cache2[index2][i].tag==tag2&&cache2[index2][i].v)
                    {
                        cache2[index2].erase(cache2[index2].begin()+i);
                        cache2[index2].insert(cache2[index2].begin(),new_in2);
                        hit2 = true;
                        //cout <<"yes\n" << index << " " << tag << "\n";
                        break;
                    }
                }
                if(!hit2)
                {
                    if(cache2[index2].size()<n_ways)
                    {
                        cache2[index2].insert(cache2[index2].begin(),new_in2);
                        //miss++;
                        //cout << "rrrrr\n" << index << " " << tag <<"\n";
                    }
                    else
                    {
                        cache2[index2].pop_back();
                        cache2[index2].insert(cache2[index2].begin(),new_in2);
                        //miss++;
                        //cout << "QQQQ\n" << index << " " << tag << "\n";
                    }
                    miss_2++;
                }
            }

	}

	//cout << "\n";
	//cout << "Miss rate = " << (double)miss/access*100 << "%\n";
    /*for(int j = 0; j < line/n_ways; j++)
		for(int i = 0; i < cache[index].tag.size(); i++)
            cout << cache[index].tag[i] << " ";
    */
	for(int i=0;i<line1;i++)
        cache1[i].clear();
    for(int i=0;i<line2;i++)
        cache2[i].clear();

    tmsc3 = miss_2 * (1+32*(1+100+1+10)+4*(1+10+1+1)+1+1);
    tmsc3 += (access_1_2 - miss_2) * (1+4*(1+10+1+1)+1+1);
    tmsc3 += (access - access_1_2) * (1+1+1);
	//fclose(fp);

}


int main(int argc, char *argv[])
{
    string inp;
    inp = argv[1];
    FILE *fp = fopen(inp.c_str(), "r");
	unsigned int addr0, addr1, addr2;
	int m, n, p;
	fscanf(fp,"%x%x%x",&addr0,&addr1,&addr2);
	fscanf(fp,"%d%d%d",&m,&n,&p);

	int a[m][n],b[n][p],c[m][p];

	for(int i=0;i<m;i++)
        for(int j=0;j<n;j++)
            fscanf(fp,"%d",&a[i][j]);
    for(int i=0;i<n;i++)
        for(int j=0;j<p;j++)
            fscanf(fp,"%d",&b[i][j]);
    for(int i=0;i<m;i++)
        for(int j=0;j<p;j++)
            c[i][j] = 0;
    for(int i=0;i<m;i++)
        for(int j=0;j<p;j++)
            for(int k=0;k<n;k++)
            {
                c[i][j] += a[i][k] * b[k][j];

                addr.push_back((unsigned int)4*(i*p+j)+addr2);
                addr.push_back((unsigned int)4*(i*n+k)+addr0);
                addr.push_back((unsigned int)4*(k*p+j)+addr1);
                addr.push_back((unsigned int)4*(i*p+j)+addr2);
            }
    ofstream output (argv[2]);
    for(int i=0;i<m;i++)
    {
        for(int j=0;j<p;j++)
            output << c[i][j] << " ";
        output << endl;
    }

    simulate(K/2,8);
    simulate_2level(128,4*K,8);

    output << 2+(5+p*(5+n*22+2)+2)*m+2+1 << " " <<tmsc1 << " " << tmsc2 << " " << tmsc3;


    fclose(fp);
}
