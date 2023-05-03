all: direct_mapped_cache.out direct_mapped_cache_lru.out
direct_mapped_cache.out: direct_mapped_cache.cpp
	g++ direct_mapped_cache.cpp -o direct_mapped_cache.out
direct_mapped_cache_lru.out: direct_mapped_cache_lru.cpp
	g++ direct_mapped_cache_lru.cpp -o direct_mapped_cache_lru.out
clean:
	rm -f direct_mapped_cache.out direct_mapped_cache_lru.out