#include <iostream>
#include <stdio.h>
#include <math.h>
#include <vector>

using namespace std;

const int K = 1024;

struct cache_content
{
	int used_t;
	vector<unsigned int> tag;
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
    int block_size = 64;
	int offset_bit = (int)log2(block_size);
	int line = (cache_size >> (offset_bit));
	int index_bit = (int)log2(cache_size / block_size);
	int access = 0;
	int miss = 0;

	//cache_content *cache = new cache_content[line];
    cache_content *cache = new cache_content[line/n_ways];

    cout << "cache line: " << line << endl;


	for(int j = 0; j < line/n_ways; j++)
		cache[j].used_t = 0;

    FILE *fp = fopen("RADIX.txt", "r");  // read file

    while(fscanf(fp, "%x", &x) != EOF)
    {
        //cout << access << " ";
		access++;
		//cout << hex << x << " ";
		index_pre = (x >> offset_bit) & (line - 1);
		index = index_pre % (line / n_ways);
		tag = x >> (index_bit + offset_bit);

        /*if(cache[index].used_t==0)
        {
            cache[index].tag.insert(cache[index].tag.end(),tag);
            cache[index].used_t++;
            miss++;
        }*/


            bool hit=false;//key_hit
            for(int i=0;i<cache[index].used_t;i++)
            {
                if(cache[index].tag[i]==tag)
                {
                    cache[index].tag.erase(cache[index].tag.begin()+i);
                    cache[index].tag.insert(cache[index].tag.begin(),tag);
                    hit = true;

                    //cout <<"yes\n" << index << " " << tag << "\n";
                    break;
                }
            }
            if(!hit)
            {
                if(cache[index].used_t<n_ways)
                {
                    cache[index].tag.insert(cache[index].tag.begin(),tag);
                    cache[index].used_t++;
                    miss++;
                    //cout << "rrrrr\n" << index << " " << tag <<"\n";
                }
                else
                {
                    cache[index].tag.pop_back();
                    cache[index].tag.insert(cache[index].tag.begin(),tag);
                    miss++;
                    //cout << "QQQQ\n" << index << " " << tag << "\n";
                }
            }


	}

	cout << "\n";
	cout << "Miss rate = " << (double)miss/access*100 << "%\n";
    /*for(int j = 0; j < line/n_ways; j++)
		for(int i = 0; i < cache[index].tag.size(); i++)
            cout << cache[index].tag[i] << " ";
    */
	for(int i=0;i<line/n_ways;i++)
        cache[i].tag.clear();
	delete [] cache;

	fclose(fp);

}

int main()
{
	// Let us simulate 4KB cache with 16B blocks
	simulate(4 * K, 64);
}
