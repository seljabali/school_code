package btree;

import diskmgr.Page;
import exceptions.ConstructPageException;
import exceptions.HashEntryNotFoundException;
import exceptions.InvalidFrameNumberException;
import exceptions.IteratorException;
import exceptions.KeyNotMatchException;
import exceptions.PageUnpinnedException;
import exceptions.ReplacerException;
import exceptions.ScanDeleteException;
import exceptions.ScanIteratorException;
import global.AttrType;
import global.GlobalConst;
import global.PageId;
import global.RID;
import global.Minibase;

import index.IndexFileScan;
import index.Key;
import index.KeyEntry;

import java.io.IOException;
import java.util.LinkedList;

import btree.page.BTLeafPage;
import btree.page.BTIndexPage;
import btree.page.BTSortedPage;
import btree.page.BTHeaderPage;


public class BTFileScan extends IndexFileScan implements GlobalConst
{
	public int maxKeysize, dupKeyCount;
	public Key low, high;
	public boolean firstTime, done, tilEnd, delOccured, dupIsNext, findingNext, deleting;
	BTLeafPage curLeaf;
	KeyEntry curEntry, dupEntry, prevEntry, nextEntry;
	BTreeFile  myTree;
	RID rid;

	public KeyEntry get_next() throws ScanIteratorException
	{
		if (firstTime)
		{
			firstTime = false;
			dupEntry = curEntry;
			prevEntry = curEntry; 
			return curEntry;
		}
		else
		{
			//Unpin Previous page            (PageId)curEntry.getData()
			
			try{Minibase.JavabaseBM.unpinPage(curLeaf.getCurPage(), false/* not dirty */);}
			catch (Exception e) {throw new ScanIteratorException(e, "Error unpinning curPage");}
			
			//Try Getting The Next Entry In The Page
			try{
				findingNext = false;
				if (curEntry == null)
				{
					curEntry = prevEntry;
					findingNext = true;
				}
				curEntry = _traverseTree(myTree.getHeaderPage().get_rootId(), myTree.getHeaderPage().get_keyType());
			}
			catch (Exception e){
				throw new ScanIteratorException(e, "Error when reading next Entry");}
			
			return curEntry;
		}		
	}
	
	public void delete_current() throws ScanDeleteException
	{
		deleting = true;
		findingNext = false;
		try{
			//Delete curEntry
			_traverseTree(myTree.getHeaderPage().get_rootId(), myTree.getHeaderPage().get_keyType());

			deleting = false;
			curEntry = get_next();
		}
		catch(Exception e){throw new ScanDeleteException("");}
		
	}
	
	/**This function  covers delete_current and get_next
	 * 
	 * get_Next: We first find the currentEntry in the tree. We then get the next entry that isn't larger than the HighKey
	 * 				then we return it.
	 * 
	 * delete_current: We first find the current key. Then set it to preEntry then we delete the curEntry and return null
	 * 						delete_curent must then call it again will delOccured to set the curEntry to the next entry.
	 */
	private KeyEntry _traverseTree(PageId currentPageId, int keyType) throws IOException, ConstructPageException,
	IteratorException, HashEntryNotFoundException, InvalidFrameNumberException, PageUnpinnedException,ReplacerException
	{
	
	BTSortedPage sortedPage = new BTSortedPage(currentPageId, keyType);
	
	// for index pages, go through their child pages
	if (sortedPage.getType() == BTSortedPage.INDEX)
	{
		BTIndexPage indexPage = new BTIndexPage((Page) sortedPage, keyType);
		KeyEntry temp, pimp;

		temp = _traverseTree(indexPage.getPrevPage(), keyType);
		
		if (temp != null)
			return temp;
		
		//Lowest index levels
		RID rid = new RID();
		for (KeyEntry entry = indexPage.getFirst(rid); 
			 entry != null;  
			 entry = indexPage.getNext(rid))
		{
			pimp = _traverseTree((PageId) entry.getData(), keyType);
			
			//if (pimp != null)
				return pimp;
		}
	}
	
	// for leaf pages, iterate through the keys and print them out
	else if (sortedPage.getType() == BTSortedPage.LEAF)
	{
		BTLeafPage leafPage = new BTLeafPage((Page) sortedPage, keyType);
		RID rid2 = new RID();
		int compare, upBound = 0;
		
		for (KeyEntry entry = leafPage.getFirst(rid2); entry != null; entry = leafPage.getNext(rid2))
		{
			try{
				compare = entry.key.compareTo(curEntry.key);
				if (high != null)
					upBound = entry.key.compareTo(high);}
			catch (Exception e) {throw new IOException("Yeah so they don't somehow match");}
			
			//We found the entry that needs to be returned => implementing get_next()
			if(findingNext && (upBound <= 0 /*|| tilEnd*/))
			{
				return entry; 
			}
			
			//We hit curEntry 
			if(compare == 0)
			{
				//if we are deleting
				if (deleting)
				{
					prevEntry = curEntry;
					try{
						System.out.println("Delete: " + entry.key + "\n");
						myTree.delete(entry.key, null/*(RID)entry.getData()*/);} //Correct way of getting RID?
					catch (Exception e){throw new IOException("");}
					
					return null;
				}
				findingNext = true;
			}
		}
		return null;
	}
		return null;
	}		


	public int keysize(){
		return maxKeysize;
	}

	public void destroyBTreeFileScan() throws IOException,
			exceptions.InvalidFrameNumberException, exceptions.ReplacerException,
			exceptions.PageUnpinnedException, exceptions.HashEntryNotFoundException
	{
		//Unpin Previous page            (PageId)curEntry.getData()
		//try{Minibase.JavabaseBM.unpinPage(curLeaf.getCurPage(), false/* not dirty */);}
		//catch (Exception e) {throw new ScanIteratorException(e, "Error unpinning curPage");}
	}

}
