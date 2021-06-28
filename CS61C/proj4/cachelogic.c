/*Sami Eljabali
 *cs61c-by
 */
#include "tips.h"
#include "util.h"

char* lru_to_string(int assoc_index, int block_index){
  /* Buffer to print lru information -- increase size as needed. */
  static char buffer[9];
  sprintf(buffer, "%u", cache[assoc_index].block[block_index].lru.value);

  return buffer;
}

void init_lru(int assoc_index, int block_index){
  cache[assoc_index].block[block_index].lru.value = 0;
}

void accessMemory(address addr, word* data, WriteEnable we){
    
    int index = (addr << (32 - log2(set_count) - log2(block_size))) >> (32 - log2(set_count));
    int tag = addr >> (log2(set_count) + log2(block_size));
    int offset = addr << (32 - log2(block_size)) >> (32 - log2(block_size));
    int i = 0, invalid = -1, j = 0;
    static int lru_counter = 0;
    address old_addr;
    
    if(assoc == 0){
	accessDRAM(addr, (byte*)data, WORD_SIZE, we);
	return;
    }
  
  lru_counter++;

  if(we == READ){
      for(i=0; i < assoc; i++){
	  if((tag == cache[index].block[i].tag) && (cache[index].block[i].valid == VALID)){
	      memcpy(data, cache[index].block[i].data+offset,4);
	      if(policy == LRU)
		  cache[index].block[i].lru.value = lru_counter;
	      return;
	  }
	  if((cache[index].block[i].valid == INVALID) && (invalid == -1))
	      invalid = i;
      }
      if(invalid != -1){
	  accessDRAM(addr - offset,cache[index].block[invalid].data, log2(block_size), READ);
	  memcpy(data, cache[index].block[invalid].data+offset, 4);
	  cache[index].block[invalid].valid = VALID;
	  cache[index].block[invalid].dirty = VIRGIN;
	  cache[index].block[invalid].tag = tag;
	  if(policy == LRU)
	      cache[index].block[invalid].lru.value = lru_counter;
	  return;
      }
      else{/*All is valid*/
	  if(policy == RANDOM)
	      i = randomint(assoc);
	  else{/*LRU*/
	      i=0;
	      for(j = 0; j < assoc; j++){
		  if(cache[index].block[j].lru.value < cache[index].block[i].lru.value)
		      i = j;
	      }
	   } 
	   if(memory_sync_policy == WRITE_BACK){
	       if(cache[index].block[i].dirty == DIRTY){
		   old_addr = addr << (32 - log2(block_size) - log2(set_count)) >> (32 - log2(block_size)) | (cache[index].block[i].tag
			         << (log2(block_size) + log2(set_count)));
		      accessDRAM(old_addr-offset,(byte*)cache[index].block[i].data, log2(block_size), WRITE);
		      accessDRAM(addr - offset,(byte*)cache[index].block[i].data, log2(block_size), READ);
		      memcpy(data, cache[index].block[i].data+offset,4);
		      cache[index].block[i].dirty = VIRGIN;
		      cache[index].block[i].valid = VALID;
		      cache[index].block[i].tag = tag;
		      if(policy == LRU)
			  cache[index].block[i].lru.value = lru_counter;
		      return;
	      }
	        else{
		  accessDRAM(addr - offset,cache[index].block[i].data, log2(block_size), READ);
		  memcpy(data, cache[index].block[i].data+offset,4);
		  cache[index].block[i].dirty = VIRGIN;
		  cache[index].block[i].valid = VALID;
		  if(policy == LRU)
		      cache[index].block[i].lru.value = lru_counter;
		  cache[index].block[i].tag = tag;
		  return;
	      }	
	   }
	   else{/*WRITE_THROUGH*/
	       	  accessDRAM(addr - offset,cache[index].block[i].data, log2(block_size), READ);
		  memcpy(data, cache[index].block[i].data+offset,4);
		  cache[index].block[i].dirty = VIRGIN;
		  cache[index].block[i].valid = VALID;
		  if(policy == LRU)
		      cache[index].block[i].lru.value = lru_counter;
		  cache[index].block[i].tag = tag;
		  return;
	   }
      }
  }
                                     /*******WRITE**********/
  
  if(we == WRITE){
      for(i=0; i < assoc; i++){
	  if((tag == cache[index].block[i].tag) && (cache[index].block[i].valid == VALID)){
	      memcpy(cache[index].block[i].data+offset, data, 4);
	       cache[index].block[i].valid = VALID;
	      if(policy == LRU)
		  cache[index].block[i].lru.value = lru_counter;
	      if(policy == WRITE_BACK)
		  cache[index].block[i].dirty = DIRTY;
	      else
		  accessDRAM(addr-offset,(byte*)cache[index].block[i].data, log2(block_size), WRITE);
	      return;
	  }
	  if((cache[index].block[i].valid == INVALID) && (invalid == -1))
	      invalid = i;
      }
      if(invalid != -1){
	  accessDRAM(addr - offset,cache[index].block[invalid].data, log2(block_size), READ);
	  memcpy(cache[index].block[invalid].data+offset, data, 4);
	  cache[index].block[invalid].valid = VALID;
	  cache[index].block[invalid].tag = tag;
	  if(policy == LRU)
	      cache[index].block[invalid].lru.value = lru_counter;
	  if(policy == WRITE_BACK)
	      cache[index].block[invalid].dirty = DIRTY;
	  else
	      accessDRAM(addr-offset,(byte*)cache[index].block[invalid].data, log2(block_size), WRITE);
	  return;
      }
      else{/*if all is valid*/
	  if(policy == RANDOM)
	      i = randomint(assoc);
	  else{/*LRU*/
	      i=0;
	      for(j = 0; j < assoc; j++){
		  if(cache[index].block[j].lru.value < cache[index].block[i].lru.value)
		      i = j;
	      }
	   } 
	   if(memory_sync_policy == WRITE_BACK){
	       if(cache[index].block[i].dirty == DIRTY){
		      old_addr = addr <<(32-log2(block_size) - log2(set_count)) >> (32 - log2(block_size)) | (cache[index].block[i].tag
			            <<(log2(block_size) + log2(set_count)));
		      accessDRAM(old_addr-offset,(byte*)cache[index].block[i].data, log2(block_size), WRITE);
		      accessDRAM(addr - offset,(byte*)cache[index].block[i].data, log2(block_size), READ);
		      memcpy(cache[index].block[i].data, data, 4);
		      cache[index].block[i].dirty = DIRTY;
		      cache[index].block[i].valid = VALID;
		      cache[index].block[i].tag = tag;
		      if(policy == LRU)
			  cache[index].block[i].lru.value = lru_counter;
		      return;
	      }
	      else{
		  accessDRAM(addr - offset,cache[index].block[i].data, log2(block_size), READ);
		  memcpy(cache[index].block[i].data+offset, data, 4);
		  cache[index].block[i].dirty = DIRTY;
		  cache[index].block[i].valid = VALID;
		  if(policy == LRU)
		      cache[index].block[i].lru.value = lru_counter; 
		  cache[index].block[i].tag = tag;
		  return;
	      }	
	   }
	   else{/*WRITE_THROUGH*/
		accessDRAM(addr-offset, cache[index].block[i].data, log2(block_size), READ);
		memcpy(cache[index].block[i].data + offset, data, 4);
		accessDRAM(addr-offset, cache[index].block[i].data, log2(block_size), WRITE);
		cache[index].block[i].valid = VALID;
		cache[index].block[i].tag = tag;
		cache[index].block[i].dirty = DIRTY;
		if(policy == LRU)
		    cache[index].block[i].lru.value = lru_counter;
	   }
      }
      
  }
}

      
	     
