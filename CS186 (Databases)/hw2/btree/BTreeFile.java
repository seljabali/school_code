/*
 * @(#) bt.java   98/03/24
 * Copyright (c) 1998 UW.  All Rights Reserved.
 *         Author: Xiaohu Li (xioahu@cs.wisc.edu).
 *
 */

package btree;

import diskmgr.Page;
import exceptions.AddFileEntryException;
import exceptions.ConstructPageException;
import exceptions.ConvertException;
import exceptions.DeleteFashionException;
import exceptions.DeleteFileEntryException;
import exceptions.DeleteRecException;
import exceptions.FreePageException;
import exceptions.GetFileEntryException;
import exceptions.HashEntryNotFoundException;
import exceptions.IndexFullDeleteException;
import exceptions.IndexInsertRecException;
import exceptions.IndexSearchException;
import exceptions.InsertException;
import exceptions.InsertRecException;
import exceptions.InvalidFrameNumberException;
import exceptions.IteratorException;
import exceptions.KeyNotMatchException;
import exceptions.KeyTooLongException;
import exceptions.LeafDeleteException;
import exceptions.LeafInsertRecException;
import exceptions.LeafRedistributeException;
import exceptions.NodeNotMatchException;
import exceptions.PageUnpinnedException;
import exceptions.PinPageException;
import exceptions.RecordNotFoundException;
import exceptions.RedistributeException;
import exceptions.ReplacerException;
import exceptions.UnpinPageException;
import global.AttrType;
import global.GlobalConst;
import global.Minibase;
import global.PageId;
import global.RID;
import heap.HFPage;
import index.IndexFile;
import index.Key;
import index.KeyEntry;

import java.io.DataOutputStream;
import java.io.FileOutputStream;
import java.io.IOException;

import btree.page.BTIndexPage;
import btree.page.BTLeafPage;
import btree.page.BTSortedPage;
import btree.page.BTHeaderPage;
 
public class BTreeFile extends IndexFile implements GlobalConst
{
	public static final int NAIVE_DELETE = 0;

	public static final int FULL_DELETE = 1;

	private final static int MAGIC0 = 1989;

	private BTHeaderPage theHeadPtr;
	/**
	 * Access method to data member.
	 * 
	 * @return Return a BTreeHeaderPage object that is the header page of this
	 *         btree file.
	 */
	public BTHeaderPage getHeaderPage()
	{
		return theHeadPtr;
	}
	
	/**
	 * BTreeFile class an index file with given filename should already exist;
	 * this opens it.
	 * 
	 * @param filename
	 *            the B+ tree file name. Input parameter.
	 * @exception GetFileEntryException
	 *                can not ger the file from DB
	 * @exception PinPageException
	 *                failed when pin a page
	 * @exception ConstructPageException
	 *                BT page constructor failed
	 */
	public BTreeFile(String filename) throws GetFileEntryException,
			PinPageException, ConstructPageException
	{
		try 
		{
			PageId aPageId = Minibase.JavabaseDB.get_file_entry(filename);
			BTHeaderPage aHeaderPg = new BTHeaderPage(aPageId);
			theHeadPtr = aHeaderPg;
		}
		catch (Exception e)
		{
			throw new GetFileEntryException(e, "GetFileEntryException");
		}
		
	}

	/**
	 * if index file exists, open it; else create it.
	 * 
	 * @param filename
	 *            file name. Input parameter.
	 * @param keytype
	 *            the type of key. Input parameter.
	 * @param keysize
	 *            the maximum size of a key. Input parameter.
	 * @param delete_fashion
	 *            full delete or naive delete. Input parameter. It is either
	 *            DeleteFashion.NAIVE_DELETE or DeleteFashion.FULL_DELETE.
	 * @exception GetFileEntryException
	 *                can not get file
	 * @exception ConstructPageException
	 *                page constructor failed
	 * @exception IOException
	 *                error from lower layer
	 * @exception AddFileEntryException
	 *                can not add file into DB
	 */
	public BTreeFile(String filename, int keytype, int keysize,
			int delete_fashion) throws GetFileEntryException,
			ConstructPageException, IOException, AddFileEntryException
	{
		try 
		{
			PageId aPageId = Minibase.JavabaseDB.get_file_entry(filename);
			if (aPageId != null)
			{
				BTHeaderPage aHeaderPg = new BTHeaderPage(aPageId);
				theHeadPtr = aHeaderPg;
			}
			else
			{
				throw new GetFileEntryException("GetFileEntryException");
			}
		}
		catch (Exception e)             //*******ASK newPageId and add_fileentry .getPageId or root_id****//
		{
			BTHeaderPage aHeaderPg = new BTHeaderPage();
			try 
			{
				Minibase.JavabaseDB.add_file_entry(filename, aHeaderPg.getPageId());
				aHeaderPg.set_deleteFashion(delete_fashion);
				aHeaderPg.set_keyType((short)keytype);    /**********/
				aHeaderPg.set_maxKeySize(keysize); 
				theHeadPtr = aHeaderPg;
			}
			catch (Exception e2)
			{
				throw new AddFileEntryException(e, "AddFileEntryException");
			}
			
		}
	}

	/**
	 * Close the B+ tree file. Unpin header page.
	 * 
	 * @exception PageUnpinnedException
	 *                error from the lower layer
	 * @exception InvalidFrameNumberException
	 *                error from the lower layer
	 * @exception HashEntryNotFoundException
	 *                error from the lower layer
	 * @exception ReplacerException
	 *                error from the lower layer
	 */
	public void close() throws PageUnpinnedException,
			InvalidFrameNumberException, HashEntryNotFoundException,
			ReplacerException
	{
	}

	
    public void change_pgId(BTIndexPage index_parent, PageId oldPgId, PageId new_pg) throws IteratorException,
    IndexInsertRecException, DeleteRecException
    {   
        Key key;
        try
        {
            key = find_key(index_parent, oldPgId);   
        }
        catch(Exception e)
        {
            throw new IteratorException(e, "IteratorException");
        }
        try
        {
            index_parent.deleteKey(key);
        }
        catch (Exception e)
        {
            throw new DeleteRecException(e, "DeleteRecException");
        }
        try
        {
            index_parent.insertKey(key, new_pg);
        }
        catch (Exception e)
        {
            throw new IndexInsertRecException(e, "IndexInsertRecException");
        }
       
    }
	
	/**
	 * Destroy entire B+ tree file.
	 * 
	 * @exception IOException
	 *                error from the lower layer
	 * @exception IteratorException
	 *                iterator error
	 * @exception UnpinPageException
	 *                error when unpin a page
	 * @exception FreePageException
	 *                error when free a page
	 * @exception DeleteFileEntryException
	 *                failed when delete a file from DM
	 * @exception ConstructPageException
	 *                error in BT page constructor
	 * @exception PinPageException
	 *                failed when pin a page
	 */
    public void destroyFile() throws IOException, IteratorException,
    UnpinPageException, FreePageException, DeleteFileEntryException,
    ConstructPageException, PinPageException, IndexSearchException
    {
            PageId rootId = getHeaderPage().get_rootId();

            if (rootId.pid == INVALID_PAGE){
                    System.out.println("The Tree is Empty!!!");
                    return;
            }
            _destroyHelper(rootId);
            try {
                    Minibase.JavabaseBM.freePage(getHeaderPage().getCurPage());
            } catch (Exception e) {throw new IOException("IOException");}
    }

    public void _destroyHelper(PageId page) throws ConstructPageException,
    FreePageException, IOException, IteratorException, IndexSearchException
    {
    		RID rid = new RID();
            BTSortedPage sp = new BTSortedPage(page,getHeaderPage().get_keyType());
            if (sp.getType() == BTSortedPage.LEAF)
            {
                    BTLeafPage leafPage = new BTLeafPage((Page)sp, getHeaderPage().get_keyType());
                    try{
                            Minibase.JavabaseBM.freePage(leafPage.getCurPage());
                    }
                    catch (Exception e){throw new FreePageException(e, "FreePageException");}
            }
            else
            {
                    BTIndexPage indexPage = new BTIndexPage((Page) sp, getHeaderPage().get_keyType());
                    
                    _destroyHelper(indexPage.getPrevPage());
                    
                    for (KeyEntry entry = indexPage.getFirst(rid); entry != null;entry = indexPage.getNext(rid)){
                    	_destroyHelper((PageId)entry.getData());
                    }
                    try{
                            Minibase.JavabaseBM.freePage(indexPage.getCurPage());
                    }
                    catch (Exception e){throw new FreePageException(e, "FreePageException");}
            }
    }


	/**
	 * insert record with the given key and rid
	 * 
	 * @param key
	 *            the key of the record. Input parameter.
	 * @param rid
	 *            the rid of the record. Input parameter.
	 * @exception KeyTooLongException
	 *                key size exceeds the max keysize.
	 * @exception KeyNotMatchException
	 *                key is not integer key nor string key
	 * @exception IOException
	 *                error from the lower layer
	 * @exception LeafInsertRecException
	 *                insert error in leaf page
	 * @exception IndexInsertRecException
	 *                insert error in index page
	 * @exception ConstructPageException
	 *                error in BT page constructor
	 * @exception UnpinPageException
	 *                error when unpin a page
	 * @exception PinPageException
	 *                error when pin a page
	 * @exception NodeNotMatchException
	 *                node not match index page nor leaf page
	 * @exception ConvertException
	 *                error when convert between revord and byte array
	 * @exception DeleteRecException
	 *                error when delete in index page
	 * @exception IndexSearchException
	 *                error when search
	 * @exception IteratorException
	 *                iterator error
	 * @exception LeafDeleteException
	 *                error when delete in leaf page
	 * @exception InsertException
	 *                error when insert in index page
	 */
	public void insert(Key key, RID rid) throws KeyTooLongException,
			KeyNotMatchException, LeafInsertRecException,
			IndexInsertRecException, ConstructPageException,
			UnpinPageException, PinPageException, NodeNotMatchException,
			ConvertException, DeleteRecException, IndexSearchException,
			IteratorException, LeafDeleteException, InsertException,
			IOException

	{
		if (getHeaderPage().get_rootId().getPid() == INVALID_PAGE)
		{
			BTLeafPage firstLeaf = new BTLeafPage(key.getKeyType());
			firstLeaf.insertRecord(key, rid);
			theHeadPtr.set_rootId(firstLeaf.getCurPage());
			
			try 
			{
				Minibase.JavabaseBM.unpinPage(firstLeaf.getCurPage(), true);
			}
			catch (Exception e)
			{
				throw new UnpinPageException(e, "UnpinPageException");
			}
		}
		else
		{
			PageId aPg = getHeaderPage().get_rootId();
		
			insert_helper(key, rid, aPg);
		}
		
		
	}
	
	
	public PageId insert_helper(Key key, RID rid, PageId aPg) throws KeyTooLongException,
			KeyNotMatchException, LeafInsertRecException,
			IndexInsertRecException, ConstructPageException,
			UnpinPageException, PinPageException, NodeNotMatchException,
			ConvertException, DeleteRecException, IndexSearchException,
			IteratorException, LeafDeleteException, InsertException,
			IOException	
	{
        //
        //PageId buggy = getHeaderPage().get_rootId();
        //int bugint = buggy.pid;
        //
       
        BTSortedPage sortedPage_aPg ;
        try
        {
            sortedPage_aPg = new BTSortedPage(aPg, getHeaderPage().get_keyType());   //*************/
        }
        catch (Exception e)
        {
            throw new ConstructPageException(e, "ConstructPageException");
        }
        //
        //IF aPG is A LEAF
        //
        if (sortedPage_aPg.getType() == BTSortedPage.LEAF)
        {
      
            BTLeafPage leaf_aPg = new BTLeafPage((Page) sortedPage_aPg, getHeaderPage().get_keyType());
           
            KeyEntry entry = new KeyEntry(key, rid);
           
            //if aPg has space
            if (leaf_aPg.available_space() >= entry.getSizeInBytes())
            {
                try
                {
                    leaf_aPg.insertRecord(entry);
                    try
                    {
                        Minibase.JavabaseBM.unpinPage(leaf_aPg.getCurPage(), true);
                    }
                    catch(Exception e)
                    {
                        throw new UnpinPageException(e, "UnpinPageException");   
                    }
                    return null;
                }
                catch (Exception e)
                {
                    throw new LeafInsertRecException(e, "LeafInsertRecException");       
                }
            }       
            else  //aPg->leaf didn't have space
            {
                //SPLIT should return a LeafPage
                //don't unpin in SPLIT
                BTLeafPage new_leaf = split_leaf(leaf_aPg, entry);
               
                //IF WHAT GOT SPLIT WAS THE ROOT LEAF.
                if (getHeaderPage().get_rootId().pid == leaf_aPg.getCurPage().pid )
                {
                    KeyEntry first_key = new_leaf.getFirst(new RID());
                   
                    //make a new index pg and copy up the rec pointing to the new_leaf and the orig leaf
                    BTIndexPage new_root = new BTIndexPage(getHeaderPage().get_keyType());
                    new_root.insertKey(first_key.key, new_leaf.getCurPage());
                    new_root.setLeftLink(leaf_aPg.getCurPage());
                   
                    //update the Header to point to the new_root
                    getHeaderPage().set_rootId(new_root.getCurPage());
                   
                    //
                    KeyEntry an_entry = new_root.getFirst(new RID());
                    PageId apagina = new_root.getPageNoByKey(an_entry.key);
                    PageId left = new_root.getLeftLink();
                    //
                    try
                    {
                        Minibase.JavabaseBM.unpinPage(new_root.getCurPage(), true);   //dirty page! write it
                    }
                    catch (Exception e)
                    {
                        throw new UnpinPageException(e, "UnpinPageException");
                    }
                   
                   
                    try    /*************************/
                    {
                        Minibase.JavabaseBM.unpinPage(new_leaf.getCurPage(), true);   //dirty page! write it
                    }
                    catch (Exception e)
                    {
                        throw new UnpinPageException(e, "UnpinPageException");
                    }
                    try    /*************************/
                    {
                        Minibase.JavabaseBM.unpinPage(leaf_aPg.getCurPage(), true);   //dirty page! write it
                    }
                    catch (Exception e)
                    {
                        throw new UnpinPageException(e, "UnpinPageException");
                    }
                    return null;
                }
                else
                {
                    try    /*************************/
                    {
                        Minibase.JavabaseBM.unpinPage(new_leaf.getCurPage(), true); 
                    }
                    catch (Exception e)
                    {
                        throw new UnpinPageException(e, "UnpinPageException");
                    }
                    try    /*************************/
                    {
                        Minibase.JavabaseBM.unpinPage(leaf_aPg.getCurPage(), true); 
                    }
                    catch (Exception e)
                    {
                        throw new UnpinPageException(e, "UnpinPageException");
                    }
                               
                    return new_leaf.getCurPage();
                }
                   
            }
        }
        else
        {
            //
            //if aPg is an index node
            //
            if (sortedPage_aPg.getType() == BTSortedPage.INDEX)
            {
                BTIndexPage indexPage_aPg = new BTIndexPage((Page) sortedPage_aPg, getHeaderPage().get_keyType());
                PageId the_subtree;
                try
                {
                    the_subtree = find_subtree(key, indexPage_aPg);                       
                   
                }
                catch (Exception e)
                {                   
                    throw new IteratorException(e, "IteratorException");
                }
               
               
                PageId new_page = insert_helper(key, rid, the_subtree);
               
                if (new_page == null)
                {
                    try  
                    {
                        Minibase.JavabaseBM.unpinPage(indexPage_aPg.getCurPage(), true); 
                    }
                    catch (Exception e)
                    {
                        throw new UnpinPageException(e, "UnpinPageException");
                    }
                   
                    return null;
                }
                else   //there was a split
                {
                    BTSortedPage new_pg = new BTSortedPage(new_page, getHeaderPage().get_keyType());
                   
                    //if subtree is a LEAF
                    //need to copy up the first key of the new_leaf<<subtree
                    if (new_pg.getType() == BTSortedPage.LEAF )
                    {
                        BTLeafPage new_leaf = new BTLeafPage((Page) new_pg, getHeaderPage().get_keyType());
                       
                        Key first_key = new_leaf.getFirst(new RID()).key;
                       
                        KeyEntry first_entry = new KeyEntry(first_key, new_pg.getCurPage());
                       
                        //IF the current page has space for the 1st key to be inserted
                        if (sortedPage_aPg.available_space() >= first_entry.getSizeInBytes())
                        {
                            try
                            {
                                indexPage_aPg.insertKey(first_key, new_page);                               
                            }
                            catch (Exception e)
                            {
                                throw new IndexInsertRecException(e, "IndexInsertRecException");       
                            }
                           
                            try  
                            {
                                Minibase.JavabaseBM.unpinPage(indexPage_aPg.getCurPage(), true); 
                            }
                            catch (Exception e)
                            {
                                throw new UnpinPageException(e, "UnpinPageException");
                            }
                           
                            try  
                            {
                                Minibase.JavabaseBM.unpinPage(new_leaf.getCurPage(), true); 
                            }
                            catch (Exception e)
                            {
                                throw new UnpinPageException(e, "UnpinPageException");
                            }
                            //
                            try  
                            {
                                Minibase.JavabaseBM.unpinPage(the_subtree, true); 
                            }
                            catch (Exception e)
                            {
                                throw new UnpinPageException(e, "UnpinPageException");
                            }
                            return null;
                        }
                        else   //aPg ->index Page , didn't have space after a split of a sub-leaf
                        {
                            BTIndexPage new_index = split_index(indexPage_aPg, first_key, new_page);
                           
                           
                            if (getHeaderPage().get_rootId().pid == indexPage_aPg.getCurPage().pid )
                            {   
                                //make a new index pg and copy up the rec pointing to the new_leaf and the orig leaf
                                BTIndexPage new_root = new BTIndexPage(getHeaderPage().get_keyType());
                                KeyEntry first_keyE_in_newIndex = new_index.getFirst(new RID());
                                Key first_key_in_newI = first_keyE_in_newIndex.key;
                                PageId first_apg = new_index.getPageNoByKey(first_key_in_newI);
                                new_index.setLeftLink(first_apg);
                               
                                new_root.insertKey(first_key_in_newI, new_index.getCurPage());
                                new_root.setLeftLink(indexPage_aPg.getCurPage());
                               
                                //delete key from new_index
                                try
                                {
                                    new_index.deleteKey(first_key_in_newI);
                                }
                                catch (Exception e)
                                {
                                    throw new DeleteRecException(e, "DeleteRecException");       
                                }   
                               
                                //update the Header to point to the new_root
                                getHeaderPage().set_rootId(new_root.getCurPage());
                               
                                //
                                KeyEntry an_entry = new_root.getFirst(new RID());
                                PageId apagina = new_root.getPageNoByKey(an_entry.key);
                                PageId left = new_root.getLeftLink();
                               
                                //
                                try
                                {
                                    Minibase.JavabaseBM.unpinPage(new_root.getCurPage(), true);   //dirty page! write it
                                }
                                catch (Exception e)
                                {
                                    throw new UnpinPageException(e, "UnpinPageException");
                                }
                               
                               
                                try    /*************************/
                                {
                                    Minibase.JavabaseBM.unpinPage(new_index.getCurPage(), true);   //dirty page! write it
                                }
                                catch (Exception e)
                                {
                                    throw new UnpinPageException(e, "UnpinPageException");
                                }
                                try    /*************************/
                                {
                                    Minibase.JavabaseBM.unpinPage(indexPage_aPg.getCurPage(), true);   //dirty page! write it
                                }
                                catch (Exception e)
                                {
                                    throw new UnpinPageException(e, "UnpinPageException");
                                }
                                try    /*************************/
                                {
                                    Minibase.JavabaseBM.unpinPage(new_page, true);   //dirty page! write it
                                }
                                catch (Exception e)
                                {
                                    throw new UnpinPageException(e, "UnpinPageException");
                                }
                                try    /*************************/
                                {
                                    Minibase.JavabaseBM.unpinPage(the_subtree, true);   //dirty page! write it
                                }
                                catch (Exception e)
                                {
                                    throw new UnpinPageException(e, "UnpinPageException");
                                }                               
                                return null;
                            }
                            else
                            {
                                try    /*************************/
                                {
                                    Minibase.JavabaseBM.unpinPage(new_index.getCurPage(), true);   //dirty page! write it
                                }
                                catch (Exception e)
                                {
                                    throw new UnpinPageException(e, "UnpinPageException");
                                }
                                try    /*************************/
                                {
                                    Minibase.JavabaseBM.unpinPage(indexPage_aPg.getCurPage(), true);   //dirty page! write it
                                }
                                catch (Exception e)
                                {
                                    throw new UnpinPageException(e, "UnpinPageException");
                                }
                                try    /*************************/
                                {
                                    Minibase.JavabaseBM.unpinPage(new_page, true);   //dirty page! write it
                                }
                                catch (Exception e)
                                {
                                    throw new UnpinPageException(e, "UnpinPageException");
                                }
                                try    /*************************/
                                {
                                    Minibase.JavabaseBM.unpinPage(the_subtree, true);   //dirty page! write it
                                }
                                catch (Exception e)
                                {
                                    throw new UnpinPageException(e, "UnpinPageException");
                                }                               
                                return new_index.getCurPage();       
                               
                            }
                        }
                    }//IF what was split was an index
                    else
                    {                       
                        if (new_pg.getType() == BTSortedPage.INDEX)
                        {
                            BTIndexPage new_index = new BTIndexPage((Page) new_pg, getHeaderPage().get_keyType());
                           
                            //get the first key from new_index and delete it so it gets 'pushed up'
                            Key first_key = new_index.getFirst(new RID()).key;
                            PageId left_pgId = new_index.getPageNoByKey(first_key);
                           
                            try
                            {
                                new_index.deleteKey(first_key);
                            }
                            catch (Exception e)
                            {
                                throw new DeleteRecException(e, "DeleteRecException");       
                            }                           
                           
                            new_index.setLeftLink(left_pgId);
                           
                            KeyEntry first_entry = new KeyEntry(first_key, new_index.getCurPage());
                                                       
                            //If aPg has space
                            if (indexPage_aPg.available_space() >= first_entry.getSizeInBytes())
                            {
                                try
                                {
                                    indexPage_aPg.insertKey(first_key, new_page);
                                }
                                catch (Exception e)
                                {
                                    throw new IndexInsertRecException(e, "IndexInsertRecException");
                                }
                               
                               
                                try  
                                {
                                    Minibase.JavabaseBM.unpinPage(indexPage_aPg.getCurPage(), true); 
                                }
                                catch (Exception e)
                                {
                                    throw new UnpinPageException(e, "UnpinPageException");
                                }
                               
                                try  
                                {
                                    Minibase.JavabaseBM.unpinPage (new_index.getCurPage(), true); 
                                }
                                catch (Exception e)
                                {
                                    throw new UnpinPageException(e, "UnpinPageException");
                                }
                                /*rem
                                try  
                                {
                                    Minibase.JavabaseBM.unpinPage (the_subtree, true); 
                                }
                                catch (Exception e)
                                {
                                    throw new UnpinPageException(e, "UnpinPageException");
                                }*/
                                return null;                           
                            }
                            else
                            {
                                BTIndexPage new_indexPg = split_index(indexPage_aPg, first_key, new_index.getCurPage());
                               
                                try  
                                {
                                    Minibase.JavabaseBM.unpinPage(indexPage_aPg.getCurPage(), true); 
                                }
                                catch (Exception e)
                                {
                                    throw new UnpinPageException(e, "UnpinPageException");
                                }
                               
                                try  
                                {
                                    Minibase.JavabaseBM.unpinPage(new_index.getCurPage(), true); 
                                }
                                catch (Exception e)
                                {
                                    throw new UnpinPageException(e, "UnpinPageException");
                                }
                                try  
                                {
                                    Minibase.JavabaseBM.unpinPage(new_indexPg.getCurPage(), true); 
                                }
                                catch (Exception e)
                                {
                                    throw new UnpinPageException(e, "UnpinPageException");
                                }
                               
                                try  
                                {
                                    Minibase.JavabaseBM.unpinPage(the_subtree, true); 
                                }
                                catch (Exception e)
                                {
                                    throw new UnpinPageException(e, "UnpinPageException");
                                }
                               
                                return new_indexPg.getCurPage();
                            }
                        }
                    }
                    return null;
                }
            }
        }return null;		
	}

    public BTLeafPage split_leaf(BTLeafPage curLeaf, KeyEntry key_entry) throws KeyTooLongException,
    KeyNotMatchException, LeafInsertRecException,
    IndexInsertRecException, ConstructPageException,
    UnpinPageException, PinPageException, NodeNotMatchException,
    ConvertException, DeleteRecException, IndexSearchException,
    IteratorException, LeafDeleteException, InsertException,
    IOException   
    {
        Key key = key_entry.key;
       
        BTLeafPage spage = new BTLeafPage(curLeaf.getCurPage(),getHeaderPage().get_keyType() );
      
        int slots = spage.getSlotCnt ();
        KeyEntry[] array = new KeyEntry[slots+1];
        RID rid = new RID();
      
        BTLeafPage newLeaf = new BTLeafPage(getHeaderPage().get_keyType());
        KeyEntry initEntry = curLeaf.getFirst(rid);
        KeyEntry entry = curLeaf.getFirst(rid);
       
        //linking pointers only if curLeaf is not the headptr
        if (getHeaderPage().get_rootId().pid != curLeaf.getCurPage ().pid )
        {
            PageId next_pgId = curLeaf.getNextPage();
           
            if (next_pgId.pid == -1)
            {
                //no leaf node to the right
                curLeaf.setNextPage(newLeaf.getCurPage());
                newLeaf.setPrevPage(curLeaf.getCurPage());
                newLeaf.setNextPage(global.PageId.InvalidPage);                   
            }
            else
            {
                BTSortedPage sortedPage_aPg = new BTSortedPage(next_pgId, getHeaderPage().get_keyType());   //************
               
                BTLeafPage next_leaf = new BTLeafPage((Page) sortedPage_aPg, getHeaderPage().get_keyType());
               
                next_leaf.setPrevPage(newLeaf.getCurPage());
                newLeaf.setNextPage(next_leaf.getCurPage());
               
                curLeaf.setNextPage(newLeaf.getCurPage());
               
                try  
                {
                    Minibase.JavabaseBM.unpinPage(next_leaf.getCurPage(), true); 
                }
                catch (Exception e)
                {
                    throw new UnpinPageException(e, "UnpinPageException");
                }
            }
               
        }
            
        //Making key array to determine median key
        boolean hitKey = false;
        for (int i = 0; (i <= slots); i++)
        {
            if (hitKey)
            {
                array[i] = entry;
                entry = curLeaf.getNext(rid);
            }
            else
            {
                if (entry != null)
                {
                    if ( entry.key.compareTo(key) < 0)
                    {
                        array[i] = entry;
                        entry = curLeaf.getNext(rid);
                    }
                    else
                    {
                        array[i] = key_entry;
                        hitKey = true;
                    }
                }
                else
                {
                    array[i] = key_entry;
                    hitKey = true;
                }
            }
        }
  
        //Key median = new Key(array[slots/2]);
       int half = (slots+1)/2;
       
        Key median = array[half].key;
      
        //Deciding where to start the split
        boolean hitMedian = false;
        int left = 0, right = 0; int same = 0;
        for (int i = 0; i <= slots; i++)
        {
            if (array[i].key.compareTo(median) == 0) //Or do the keyCompare
            {
                hitMedian = true;
                same++;
            }
          
            if (array[i].key.compareTo(median) != 0)
            {
                if (hitMedian)
                    right++;
                else
                    left++;
            }
        }
      
        initEntry = curLeaf.getFirst(rid);
        entry = curLeaf.getFirst(rid);
        //Splitting time!
        if (left >= right)
        {
            //delete all records from curLeaf                          
            RID rid2 = new RID();
           
            KeyEntry data_entry = curLeaf.getFirst(rid2);
           
            while (data_entry != null)
            {
                try
                {
                    curLeaf.delEntry(data_entry);
                }
                catch(Exception e)
                {
                    throw new DeleteRecException(e, "DeleteRecException");
                }
                data_entry = curLeaf.getFirst(rid2);
            }
           
            for (int i = 0; i<=left-1; i++)
            {
                try
                {
                    curLeaf.insertRecord(array[i]);   
                }
                catch (Exception e)
                {
                    throw new InsertException(e, "InsertException");
                }
            } 
           
            for (int i = left; i<=slots; i++)
            {
                try
                {
                    newLeaf.insertRecord(array[i]);   
                }
                catch (Exception e)
                {
                    throw new InsertException(e, "InsertException");
                }
            }
            newLeaf.setPrevPage(curLeaf.getCurPage());
            return newLeaf;
        }
        else
        {
            //delete all records from curLeaf                          
            RID rid2 = new RID();
           
            KeyEntry data_entry = curLeaf.getFirst(rid2);
           
            while (data_entry != null)
            {
                try
                {
                    curLeaf.delEntry(data_entry);
                }
                catch(Exception e)
                {
                    throw new DeleteRecException(e, "DeleteRecException");
                }
                data_entry = curLeaf.getFirst(rid2);
            }
           
            for (int i = 0; i<=slots-right-1; i++)
            {
                try
                {
                    curLeaf.insertRecord(array[i]);   
                }
                catch (Exception e)
                {
                    throw new InsertException(e, "InsertException");
                }
            } 
           
            for (int i = slots-right; i<=slots; i++)
            {
                try
                {
                    newLeaf.insertRecord(array[i]);   
                }
                catch (Exception e)
                {
                    throw new InsertException(e, "InsertException");
                }
            }
            newLeaf.setPrevPage(curLeaf.getCurPage());
            return newLeaf;
        }
    }
	
    public BTIndexPage split_index(BTIndexPage curIndex, Key rec_key, PageId rec_PgId) throws KeyTooLongException,
    KeyNotMatchException, LeafInsertRecException,
    IndexInsertRecException, ConstructPageException,
    UnpinPageException, PinPageException, NodeNotMatchException,
    ConvertException, DeleteRecException, IndexSearchException,
    IteratorException, LeafDeleteException, InsertException,
    IOException   
    {
        
        int slots = curIndex.getSlotCnt ();
        int array_size  = slots + 1;
       
        KeyEntry[] array = new KeyEntry[array_size];
        RID rid = new RID();
       
        KeyEntry key_entry = new KeyEntry(rec_key, rec_PgId);
      
        //BTSortedPage initSpage = new BTSortedPage(page, key.getKeyType());
       
      
        BTIndexPage newIndex = new BTIndexPage(getHeaderPage().get_keyType());
       
        KeyEntry initEntry = curIndex.getFirst(rid);
        KeyEntry entry = curIndex.getFirst(rid);
      
        //Making key array to determine median key
        boolean hitKey = false;
        for (int i = 0; (i < array_size); i++)
        {
            if (hitKey)
            {
                array[i] = entry;
                entry = curIndex.getNext (rid);
            }
            else
            {
                if (entry != null)
                {
                    if ( entry.key.compareTo(rec_key) < 0)
                    {
                        array[i] = entry;
                        entry = curIndex.getNext(rid);
                    }
                    else
                    {
                        array[i] = key_entry;
                        hitKey = true;
                    }
                }
                else
                {
                    array[i] = key_entry;
                    hitKey = true;
                }
            }
        }
  
        //Key median = new Key(array[slots/2]);
        int half = (array_size)/2;
       
        Key median = array[half].key;
      
 
        initEntry = curIndex.getFirst(rid);
        entry = curIndex.getFirst(rid);
        //Splitting time!

                          
            RID rid2 = new RID();
           
            KeyEntry data_entry = curIndex.getFirst(rid2);
           
            for (int i = half; i< array_size; i++)
            {
                Key the_key;
                try
                {                   
                    the_key = array[i].key;
                   
                    PageId the_pgId = curIndex.getPageNoByKey(the_key);
                    newIndex.insertKey(the_key, the_pgId);
                   
                    try
                    {
                        curIndex.deleteKey(the_key);
                    }
                    catch(Exception e)
                    {
                        throw new DeleteRecException(e, "DeleteRecException");
                    }
                }
                catch (Exception e)
                {
                    throw new IndexInsertRecException(e, "IndexInsertRecException");
                }
               
            } 
            //PageId pagina = newIndex.getPageNoByKey(array[array_size-1].key);
           
            return newIndex;
           
    }
    
    public Key find_key(BTIndexPage index, PageId pgId) throws IteratorException
    {
        KeyEntry a_key;
        try
        {
            a_key = index.getFirst(new RID());
        }
        catch(Exception e)
        {
            throw new IteratorException(e, "IteratorException");
        }
        boolean found =false;
        while (a_key != null && found == false)
        {
            if ( ((PageId)a_key.getData()).getPid() != pgId.getPid())
            {
                a_key = index.getNext(new RID());
            }
            else
            {
                found =true;
            }               
        }
       
        try
        {
            index.getPageNoByKey(a_key.key);           
        }
        catch(Exception e2)
        {
            return null;
        }
       
        if (found == false)
            return null;
        else
            return a_key.key;
       
    }
            
    
    private PageId find_subtree(Key key, BTIndexPage index) throws KeyTooLongException,
    KeyNotMatchException, LeafInsertRecException,
    IndexInsertRecException, ConstructPageException,
    UnpinPageException, PinPageException, NodeNotMatchException,
    ConvertException, DeleteRecException, IndexSearchException,
    IteratorException, LeafDeleteException, InsertException,
    IOException     
    {
       
        int slots = index.getSlotCnt();
        KeyEntry[] array = new KeyEntry[slots];
        RID rid = new RID();
      
        KeyEntry entry = index.getFirst(rid);
        int i =0;    
       
        while (entry != null)
        {
            array[i] = entry;
            i++;   
            entry = index.getNext(rid);               
        }
       
        if (slots == 1)
        {
            if (index.getFirst(rid).key.compareTo(key) > 0)
            {
                return index.getLeftLink ();
            }
            else
            {
                try
                {
                    return index.getPageNoByKey(array[0].key);
                }
                catch (Exception e)
                {
                    throw new IndexSearchException(e, "IndexSearchException");
                }                 
            }
        }
        else
        {
            Key curr = array[0].key;
            Key next = array[1].key;
            i = 2;
                                  
            while (i <= slots-1)
            {
                if (key.compareTo(curr) < 0 )
                {
                    return index.getLeftLink();
                }
                else
                {
                    if (key.compareTo(next) < 0)
                    {
                        return index.getPageNoByKey(curr);
                    }
                    else
                    {
                        curr = next;
                        next = array[i].key;
                        i++;
                    }
                }
            }
           
           
            return index.getPageNoByKey(next);
        }
    }

    
    public boolean delete(Key key, RID rid) throws DeleteFashionException,
    LeafRedistributeException, RedistributeException,
    InsertRecException, KeyNotMatchException, UnpinPageException,
    IndexInsertRecException, FreePageException,
    RecordNotFoundException, PinPageException,
    IndexFullDeleteException, LeafDeleteException, IteratorException,
    ConstructPageException, DeleteRecException, IndexSearchException,
    IOException
	{
		if (getHeaderPage().get_rootId().getPid() == INVALID_PAGE)
		{
		    throw new RecordNotFoundException(new Exception(""), "RecordNotFoundException");
		}
		else
		{
		    PageId aPg = getHeaderPage().get_rootId();
		   
		    delete_helper(key, rid, aPg, null);
		   
		    return true;
		}
	}
	
    public void delete_pgId(BTIndexPage index_aPg, PageId del_page)throws IteratorException,
    DeleteRecException
    {
        Key key;       
        try
        {
            key = find_key(index_aPg, del_page);   
        }
        catch(Exception e)
        {
            throw new IteratorException(e, "IteratorException");
        }
        try
        {
            index_aPg.deleteKey(key);
        }
        catch (Exception e)
        {
            throw new DeleteRecException(e, "DeleteRecException");
        }
    }
    
    public PageId delete_helper(Key key, RID rid, PageId aPg, BTIndexPage index_parent) throws DeleteFashionException,
    LeafRedistributeException, RedistributeException,
    InsertRecException, KeyNotMatchException, UnpinPageException,
    IndexInsertRecException, FreePageException,
    RecordNotFoundException, PinPageException,
    IndexFullDeleteException, LeafDeleteException, IteratorException,
    ConstructPageException, DeleteRecException, IndexSearchException,
    IOException
{
    BTSortedPage sortedPage_aPg ;
    try
    {
        sortedPage_aPg = new BTSortedPage(aPg, getHeaderPage().get_keyType());   //*************/
    }
    catch (Exception e)
    {
        throw new ConstructPageException(e, "ConstructPageException");
    }
    //
    //IF aPG is A LEAF
    //
    if (sortedPage_aPg.getType() == BTSortedPage.LEAF)
    {
        BTLeafPage leaf_aPg = new BTLeafPage((Page) sortedPage_aPg, getHeaderPage().get_keyType());
       
        KeyEntry entry = new KeyEntry(key, new RID());
       
        try
        {
            if (! (leaf_aPg.delEntry(entry)))
                throw new DeleteRecException("DeleteRecException");   
               
        }
        catch(Exception e)
        {
            throw new DeleteRecException(e, "DeleteRecException");
        }
       
       
        //Key first = leaf_aPg.getFirst(new RID()).key;
        //Key second = leaf_aPg.getNext(new RID()).key;
               
        //IF aPg (LEAF) IS NOT LESS THAN HALF FULL
        if ((leaf_aPg.available_space()) < ((PAGE_SIZE - HFPage.DPFIXED ) / 2))
        //if (sortedPage_aPg.getSlotCnt() > 0)
        {
            try  
            {
                Minibase.JavabaseBM.unpinPage(leaf_aPg.getCurPage(), true); 
            }
            catch (Exception e)
            {
                throw new UnpinPageException(e, "UnpinPageException");
            }
           
            return null;   
        }
        else
        {
            //IF THE PAGE LESS THAN HALF FULL
           
            //IF THE THE PAGE IS EMPTY AFTER DELETION
            //************************/
            if (leaf_aPg.getSlotCnt() == 0)
            {
                //IF THE LEAF WAS THE ONLY MEMBER OF TREE, so the root pg
                if (getHeaderPage().get_rootId().getPid() == leaf_aPg.getCurPage().getPid())
                {
                    try  
                    {
                        Minibase.JavabaseBM.unpinPage(leaf_aPg.getCurPage(), true); 
                    }
                    catch (Exception e)
                    {
                        throw new UnpinPageException(e, "UnpinPageException");
                    }
                    try  
                    {
                        Minibase.JavabaseBM.freePage(leaf_aPg.getCurPage()); 
                    }
                    catch (Exception e)
                    {
                        throw new FreePageException(e, "FreePageException");
                    }
                    try  
                    {
                        Minibase.JavabaseBM.freePage(getHeaderPage().get_rootId()); 
                    }
                    catch (Exception e)
                    {
                        throw new FreePageException(e, "FreePageException");
                    }
                    getHeaderPage().setPageId(global.PageId.InvalidPage );
                   
                   
                   
                    return null;
                }
                else
                {                           
                        PageId apage = leaf_aPg.getCurPage();
                        try
                        {
                            free_leaf(leaf_aPg);
                        }
                        catch(Exception e)
                        {
                            throw new FreePageException(e, "FreePageException");
                        };
                                               
                        return apage;                   
                   
                }
            }
            else
            {
                if (getHeaderPage().get_rootId().getPid() == leaf_aPg.getCurPage().getPid())
                {   
                    try  
                    {
                        Minibase.JavabaseBM.unpinPage(leaf_aPg.getCurPage(), true); 
                    }
                    catch (Exception e)
                    {
                        throw new UnpinPageException(e, "UnpinPageException");
                    }
                    return null;
                }
                else
                {               
                    PageId page_to_del = merge_leaf(leaf_aPg);
                       
                    if (page_to_del != null)
                    {
                        try  
                        {
                            Minibase.JavabaseBM.unpinPage(page_to_del, true); 
                        }
                        catch (Exception e)
                        {
                            throw new UnpinPageException(e, "UnpinPageException");
                        }
                       
                        try  
                        {
                            Minibase.JavabaseBM.freePage(page_to_del); 
                        }
                        catch (Exception e)
                        {
                            throw new FreePageException(e, "FreePageException");
                        }                   
                        return page_to_del;
                    }
                    else
                    {
                        try  
                        {
                            Minibase.JavabaseBM.unpinPage(leaf_aPg.getCurPage(), true); 
                        }
                        catch (Exception e)
                        {
                            throw new UnpinPageException(e, "UnpinPageException");
                        }
                        return null;
                    }
                }
            }
        }
    }
    else
    {
        //
        //if aPg is an index node
        //
        if (sortedPage_aPg.getType() == BTSortedPage.INDEX)
        {
            BTIndexPage indexPage_aPg = new BTIndexPage((Page) sortedPage_aPg, getHeaderPage().get_keyType());
            PageId the_subtree;
            try
            {
                the_subtree = find_subtree(key, indexPage_aPg);                       
               
            }
            catch (Exception e)
            {                   
                throw new IteratorException(e, "IteratorException");
            }
           
           
            PageId del_page = delete_helper(key, rid, the_subtree, indexPage_aPg);
           
            if (del_page== null)
            {
                try  
                {
                    Minibase.JavabaseBM.unpinPage(indexPage_aPg.getCurPage(), true); 
                }
                catch (Exception e)
                {
                    throw new UnpinPageException(e, "UnpinPageException");
                }
               
                return null;
            }
            else   //if there was a merge, we need to delete the del_page
            {
                delete_pgId(indexPage_aPg, del_page);
               
                //IF index_aPg IS NOT LESS THAN HALF FULL
                if (indexPage_aPg.available_space() <= ((PAGE_SIZE - HFPage.DPFIXED) / 2)  )
                {
                    try  
                    {
                        Minibase.JavabaseBM.unpinPage(indexPage_aPg.getCurPage(), true); 
                    }
                    catch (Exception e)
                    {
                        throw new UnpinPageException(e, "UnpinPageException");
                    }
                    return null;                       
                }
                //IF index_Pg IS LESS THAN HALF FULL
                else
                {
                    if (indexPage_aPg.getSlotCnt() == 0)
                    {
                        if (indexPage_aPg.getCurPage().getPid() == getHeaderPage().get_rootId().getPid()  )
                        {
                            PageId new_root = indexPage_aPg.getLeftLink();
                           
                            try  
                            {
                                Minibase.JavabaseBM.unpinPage(indexPage_aPg.getCurPage(), true); 
                            }
                            catch (Exception e)
                            {
                                throw new UnpinPageException(e, "UnpinPageException");
                            }
                            try  
                            {
                                Minibase.JavabaseBM.freePage(indexPage_aPg.getCurPage()); 
                            }
                            catch (Exception e)
                            {
                                throw new FreePageException(e, "FreePageException");
                            }
                           
                            if (new_root.getPid() != -1 )
                            {
                                getHeaderPage().set_rootId(new_root);
                                return null;
                            }
                            else
                            {
                                getHeaderPage().setPageId(global.PageId.InvalidPage);
                                return null;
                            }
                           
                        }
                        //if index is not the root and it's last entry was just deleted
                        else
                        {
                            if (indexPage_aPg.empty())
                            {                                                           
                                delete_pgId(index_parent, indexPage_aPg.getCurPage());
                                try  
                                {
                                    Minibase.JavabaseBM.unpinPage(indexPage_aPg.getCurPage(), true); 
                                }
                                catch (Exception e)
                                {
                                    throw new UnpinPageException(e, "UnpinPageException");
                                }
                                try  
                                {
                                    Minibase.JavabaseBM.freePage(indexPage_aPg.getCurPage()); 
                                }
                                catch (Exception e)
                                {
                                    throw new FreePageException(e, "FreePageException");
                                }                               
                                return null;
                            }
                            else
                            {                               
                                change_pgId(index_parent, indexPage_aPg.getCurPage(), indexPage_aPg.getLeftLink());
                                try  
                                {
                                    Minibase.JavabaseBM.unpinPage(indexPage_aPg.getCurPage(), true); 
                                }
                                catch (Exception e)
                                {
                                    throw new UnpinPageException(e, "UnpinPageException");
                                }
                                try  
                                {
                                    Minibase.JavabaseBM.freePage(indexPage_aPg.getCurPage()); 
                                }
                                catch (Exception e)
                                {
                                    throw new FreePageException(e, "FreePageException");
                                }
                                return null;
                            }
                        }
                    }
                    else
                    {
                        PageId new_del;
                        try
                        {
                            new_del = merge_indeces(indexPage_aPg, index_parent);
                        }
                        catch (Exception e)
                        {
                            throw new KeyNotMatchException(e, "KeyNotMatchException");
                        }
                       
                        if (new_del != null)
                        {
                            try  
                            {
                                Minibase.JavabaseBM.unpinPage(new_del, true); 
                            }
                            catch (Exception e)
                            {
                                throw new UnpinPageException(e, "UnpinPageException");
                            }
                            try  
                            {
                                Minibase.JavabaseBM.freePage(new_del); 
                            }
                            catch (Exception e)
                            {
                                throw new FreePageException(e, "FreePageException");
                            }
                            return new_del;
                        }
                        else
                        {
                            try  
                            {
                                Minibase.JavabaseBM.unpinPage(indexPage_aPg.getCurPage(), true); 
                            }
                            catch (Exception e)
                            {
                                throw new UnpinPageException(e, "UnpinPageException");
                            }
                            return null;
                        }
                           
                    }
                }
            }
        }
    }return null;
}
	
    public PageId merge_leaf(BTLeafPage leaf) throws DeleteFashionException,
    LeafRedistributeException, RedistributeException,
    InsertRecException, KeyNotMatchException, UnpinPageException,
    IndexInsertRecException, FreePageException,
    RecordNotFoundException, PinPageException,
    IndexFullDeleteException, LeafDeleteException, IteratorException,
    ConstructPageException, DeleteRecException, IndexSearchException,
    IOException
{
   
    PageId left_sib;
    try
    {
        left_sib = leaf.getPrevPage();   
        //if there is a leftsibling
        BTSortedPage sortedPage_aPg ;
        if (left_sib.pid != -1)
        {
            try           
            {
                sortedPage_aPg = new BTSortedPage(left_sib, getHeaderPage().get_keyType());   //*************/
            }
            catch (Exception e)
            {
                throw new ConstructPageException(e, "ConstructPageException");
            }
       
            BTLeafPage leaf_leftsib = new BTLeafPage((Page) sortedPage_aPg, getHeaderPage().get_keyType());
               
            //IF the left_sib IS LESS THAN HALF FULL, do the merging
            if ((leaf_leftsib.available_space()) > ((PAGE_SIZE - HFPage.DPFIXED) / 2))
            {
                RID rid = new RID();
               
                KeyEntry data_entry = leaf.getFirst(rid),
                         first_dataentry = data_entry;
               
                               
                while (data_entry != null && rid != null)
                {
                    try
                    {
                        rid = leaf_leftsib.insertRecord(data_entry);                           
                    }
                    catch(Exception e)
                    {
                        throw new InsertRecException(e, "InsertRecException");
                    }
                    leaf.delEntry(data_entry);
                    data_entry = leaf.getFirst(rid);
                }
               
                //now update the pointers of the leafs
                PageId right_sib = leaf.getNextPage();
               
                leaf_leftsib.setNextPage(right_sib);
               
                BTSortedPage sortedPage_rightsib ;
                if (right_sib.getPid() != -1)
                {
                    try               
                    {
                        sortedPage_rightsib = new BTSortedPage(right_sib, getHeaderPage().get_keyType());   //*************/
                    }
                    catch (Exception e)
                    {
                        throw new ConstructPageException(e, "ConstructPageException");
                    }
           
                    BTLeafPage leaf_rightsib = new BTLeafPage((Page) sortedPage_rightsib, getHeaderPage().get_keyType());
               
                    leaf_rightsib.setPrevPage(left_sib);
                           
                    //unpin two other  pages
                    try  
                    {
                        Minibase.JavabaseBM.unpinPage(leaf_rightsib.getCurPage(), true); 
                    }
                    catch (Exception e)
                    {
                        throw new UnpinPageException(e, "UnpinPageException");
                    }
                }
               
                try  
                {
                    Minibase.JavabaseBM.unpinPage(leaf_leftsib.getCurPage(), true); 
                }
                catch (Exception e)
                {
                    throw new UnpinPageException(e, "UnpinPageException");
                }
                return leaf.getCurPage ();                   
            }
            else
            {
                try  
                {
                    Minibase.JavabaseBM.unpinPage(leaf_leftsib.getCurPage(), true); 
                }
                catch (Exception e)
                {
                    throw new UnpinPageException(e, "UnpinPageException");
                }
                return merge_wRightsib(leaf);
            }
        }
        else
        {
            return merge_wRightsib(leaf);
        }
    }
    catch (Exception e)
    {
        return merge_wRightsib(leaf);
       
    }
}
    
    public PageId merge_wRightsib(BTLeafPage leaf) throws DeleteFashionException,
    LeafRedistributeException, RedistributeException,
    InsertRecException, KeyNotMatchException, UnpinPageException,
    IndexInsertRecException, FreePageException,
    RecordNotFoundException, PinPageException,
    IndexFullDeleteException, LeafDeleteException, IteratorException,
    ConstructPageException, DeleteRecException, IndexSearchException,
    IOException
{
    PageId right_sib;
    BTSortedPage sortedPage_aPg;
    try
    {
        right_sib = leaf.getNextPage();   
        //if there is a leftsibling
        if (right_sib == global.PageId.InvalidPage || right_sib.getPid() == -1)
        {
            return null;
        }
        else
        {               
            try           
            {
                sortedPage_aPg = new BTSortedPage(right_sib, getHeaderPage().get_keyType());   //*************/
            }
            catch (Exception e)
            {
                throw new ConstructPageException(e, "ConstructPageException");
            }

       
            BTLeafPage leaf_rightsib = new BTLeafPage((Page) sortedPage_aPg, getHeaderPage().get_keyType());
               
            //IF the right_sib IS LESS THAN HALF FULL, do the merging
            if ((leaf_rightsib.available_space()) > ((PAGE_SIZE - HFPage.DPFIXED) / 2))
            {
                RID rid = new RID();
               
                KeyEntry data_entry = leaf_rightsib.getFirst(rid);                 
               
                               
                while (data_entry != null)
                {
                    try
                    {
                        leaf.insertRecord(data_entry);
                    }
                    catch(Exception e)
                    {
                        throw new InsertRecException(e, "InsertRecException");
                    }
                    leaf_rightsib.delEntry(data_entry);
                    data_entry = leaf_rightsib.getFirst(rid);
                }
               
                //now update the pointers of the leafs
                PageId left_sib = leaf.getPrevPage();
               
                if (left_sib.getPid() != -1)
                {
                    leaf_rightsib.setPrevPage(left_sib);
               
                    BTSortedPage sortedPage_leftsib ;
                    try
                    {
                        sortedPage_leftsib = new BTSortedPage(left_sib, getHeaderPage().get_keyType());   //*************/
                    }
                    catch (Exception e)
                    {
                        throw new ConstructPageException(e, "ConstructPageException");
                    }
               
                    BTLeafPage leaf_leftsib = new BTLeafPage((Page) sortedPage_leftsib, getHeaderPage().get_keyType());
                   
                    leaf_leftsib.setNextPage(right_sib);
                   
                    try  
                    {
                        Minibase.JavabaseBM.unpinPage(leaf_leftsib.getCurPage(), true); 
                    }
                    catch (Exception e)
                    {
                        throw new UnpinPageException(e, "UnpinPageException");
                    }
                }       
                               
                try  
                {
                    Minibase.JavabaseBM.unpinPage(leaf.getCurPage(), true); 
                }
                catch (Exception e)
                {
                    throw new UnpinPageException(e, "UnpinPageException");
                }
                return leaf_rightsib.getCurPage();       
            }
            else
            {
                try  
                {
                    Minibase.JavabaseBM.unpinPage(leaf_rightsib.getCurPage(), false); 
                }
                catch (Exception e)
                {
                    throw new UnpinPageException(e, "UnpinPageException");
                }
                return null;               
            }
        }
    }
    catch (Exception e)
    {           
        return null;
    }
}
    
    public PageId merge_indeces(BTIndexPage parent, BTIndexPage index ) throws IOException, ConstructPageException,
    IteratorException, HashEntryNotFoundException,InvalidFrameNumberException, PageUnpinnedException,ReplacerException,
    KeyNotMatchException, IndexInsertRecException, UnpinPageException, FreePageException
    {
        PageId left_sib,right_sib;
       
        try
        {
            left_sib = find_left_sib(parent, index.getCurPage());
        }
        catch (Exception e2)
        {
            throw new KeyNotMatchException(e2, "KeyNotMatchException");
        }
       
        try
        {
            right_sib = find_right_sib(parent, index.getCurPage());
        }
        catch (Exception e2)
        {
            throw new KeyNotMatchException(e2, "KeyNotMatchException");
        }
       
        if (left_sib != null)
        {
            BTSortedPage sortedPage_leftsib, sortedPage_rightsib;
                       
            try
            {
                sortedPage_leftsib = new BTSortedPage(left_sib, getHeaderPage().get_keyType());   //*************/
            }
            catch (Exception e)
            {
                throw new ConstructPageException(e, "ConstructPageException");
            }
            BTIndexPage leftsib = new BTIndexPage((Page) sortedPage_leftsib, getHeaderPage().get_keyType());
           
            if (leftsib.available_space() > ((PAGE_SIZE - HFPage.DPFIXED) / 2))
            {
                int slots = index.getSlotCnt();
                KeyEntry[] array = new KeyEntry[slots];
               
                KeyEntry entry;
               
                try
                {
                    entry= index.getFirst(new RID());
                }
                catch(Exception e)
                {
                    throw new IteratorException(e, "IteratorException");
                }
               
                for (int i = 0; i < slots; i++)
                {
                    array[i] = index.getNext(new RID());
                };
               
                for (int i = 0; i < slots; i++)
                {
                    try
                    {
                        leftsib.insertRecord(array[i]);
                    }
                    catch (Exception e)
                    {
                        throw new IndexInsertRecException(e, "IndexInsertRecException");
                    }
                };
               
                return index.getCurPage();

            }
            else
            {
                if (right_sib != null)
                {
                    try
                    {
                        sortedPage_rightsib = new BTSortedPage(right_sib, getHeaderPage().get_keyType());   //*************/
                    }
                    catch (Exception e)
                    {
                        throw new ConstructPageException(e, "ConstructPageException");
                    }
                    BTIndexPage rightsib = new BTIndexPage((Page) sortedPage_rightsib, getHeaderPage().get_keyType());
                               
                    if (rightsib.available_space() > ((PAGE_SIZE - HFPage.DPFIXED) / 2))
                    {
                        int slots = index.getSlotCnt();
                        KeyEntry[] array = new KeyEntry[slots];
                       
                        KeyEntry entry;
                       
                        try
                        {
                            entry= rightsib.getFirst(new RID());
                        }
                        catch(Exception e)
                        {
                            throw new IteratorException(e, "IteratorException");
                        }
                       
                        for (int i = 0; i < slots; i++)
                        {
                            array[i] = rightsib.getNext(new RID());
                        };
                       
                        for (int i = 0; i < slots; i++)
                        {
                            try
                            {
                                index.insertRecord (array[i]);
                            }
                            catch (Exception e)
                            {
                                throw new IndexInsertRecException(e, "IndexInsertRecException");
                            }
                        };
                       
                        return rightsib.getCurPage();

                    }
                    else
                    {
                        return null;
                    }
                }
                else
                {
                    return null;
                }
            }
        }return null;
               
    }
	
    
    public BTLeafPage firstLeaf(Key key, PageId page) throws ConstructPageException
	{
	
		Short type;
		BTSortedPage sortedPage = new BTSortedPage(page, key.getKeyType());
		
		try {type = sortedPage.getType();} 
		catch (Exception e) {throw new ConstructPageException(e, "Error when getting type");}
		//If its an Index
		if (type == BTSortedPage.INDEX)
		{
			BTIndexPage indexPage;
			try {indexPage = new BTIndexPage((Page) sortedPage, key.getKeyType());}
			catch (Exception e) {throw new ConstructPageException(e, "Creating a new sorted page");}
			
			PageId pageId;
			//If we are finding the first LeafPage
			if (key == null)
			{
				//Always go to the left Link
				try{ pageId = indexPage.getPrevPage();}
				catch (Exception e) {throw new ConstructPageException(e, "Getting LeftLink");}
				return firstLeaf(key, pageId);
			}
			else
			{
				//Else find appopriate link to go to
				try{ pageId = find_subtree(key, indexPage);}
				catch (Exception e) {throw new ConstructPageException(e, "Getting LeftLink");}
				return firstLeaf(key, pageId);
			}
					
		}
		//If we have reached a LeafPage then return it
		else
		{
			BTLeafPage leaf;
			try{
				leaf = new BTLeafPage(page, key.getKeyType());
			}
			catch (Exception e) {throw new ConstructPageException(e, "Error at Leaf page");}
			return leaf;
		}
	}

    public void free_leaf(BTLeafPage leaf)throws DeleteFashionException,
    LeafRedistributeException, RedistributeException,
    InsertRecException, KeyNotMatchException, UnpinPageException,
    IndexInsertRecException, FreePageException,
    RecordNotFoundException, PinPageException,
    IndexFullDeleteException, LeafDeleteException, IteratorException,
    ConstructPageException, DeleteRecException, IndexSearchException,
    IOException   
    {
        //now update the pointers of the leafs
        PageId left_sib = leaf.getPrevPage(),
               right_sib = leaf.getNextPage();
       
        BTSortedPage sortedPage_leftsib, sortedPage_rightsib ;
         
        //if leaf has both siblings
        if ((left_sib != global.PageId.InvalidPage && right_sib != global.PageId.InvalidPage) &&
                ((left_sib.getPid() != -1) && (right_sib.getPid() != -1) ))
        {
            try
            {
                sortedPage_leftsib = new BTSortedPage(left_sib, getHeaderPage().get_keyType());   //*************/
            }
            catch (Exception e)
            {
                throw new ConstructPageException(e, "ConstructPageException");
            }
            try
            {
                sortedPage_rightsib = new BTSortedPage(right_sib, getHeaderPage().get_keyType());   //*************/
            }
            catch (Exception e)
            {
                throw new ConstructPageException(e, "ConstructPageException");
            }
           
            sortedPage_rightsib.setPrevPage(left_sib);
           
            sortedPage_leftsib.setNextPage(right_sib);
           
            try  
            {
                Minibase.JavabaseBM.unpinPage(sortedPage_rightsib.getCurPage(), true); 
            }
            catch (Exception e)
            {
                throw new UnpinPageException(e, "UnpinPageException");
            }
           
            try  
            {
                Minibase.JavabaseBM.unpinPage(sortedPage_leftsib.getCurPage(), true); 
            }
            catch (Exception e)
            {
                throw new FreePageException(e, "FreePageException");
            }
           
            try  
            {
                Minibase.JavabaseBM.unpinPage(leaf.getCurPage(), true); 
            }
            catch (Exception e)
            {
                throw new FreePageException(e, "FreePageException");
            }
            try  
            {
                Minibase.JavabaseBM.freePage(leaf.getCurPage()); 
            }
            catch (Exception e)
            {
                throw new FreePageException(e, "FreePageException");
            }       
        }
        else
        {
            //leaf only has right sib
            if ((left_sib == global.PageId.InvalidPage && right_sib != global.PageId.InvalidPage) &&
                    ((left_sib.getPid() == -1) && (right_sib.getPid() != -1) ))
            {
                try
                {
                    sortedPage_rightsib = new BTSortedPage(right_sib, getHeaderPage().get_keyType());   //*************/
                }
                catch (Exception e)
                {
                    throw new ConstructPageException(e, "ConstructPageException");
                }
               
                sortedPage_rightsib.setPrevPage(global.PageId.InvalidPage );
               
               
                try  
                {
                    Minibase.JavabaseBM.unpinPage(sortedPage_rightsib.getCurPage(), true); 
                }
                catch (Exception e)
                {
                    throw new UnpinPageException(e, "UnpinPageException");
                }
                try  
                {
                    Minibase.JavabaseBM.unpinPage (leaf.getCurPage(), true); 
                }
                catch (Exception e)
                {
                    throw new FreePageException(e, "FreePageException");
                }
                try  
                {
                    Minibase.JavabaseBM.freePage(leaf.getCurPage()); 
                }
                catch (Exception e)
                {
                    throw new FreePageException(e, "FreePageException");
                }
            }
            else               
            {
                //leaf only has left sib
                if ((left_sib != global.PageId.InvalidPage && right_sib == global.PageId.InvalidPage) &&
                        ((left_sib.getPid() != -1) && (right_sib.getPid() == -1) ))
                {
                    try
                    {
                        sortedPage_leftsib = new BTSortedPage(left_sib, getHeaderPage().get_keyType());   //*************/
                    }
                    catch (Exception e)
                    {
                        throw new ConstructPageException(e, "ConstructPageException");
                    }
                   
                    sortedPage_leftsib.setNextPage(global.PageId.InvalidPage);                   
                   
                    try  
                    {
                        Minibase.JavabaseBM.unpinPage(sortedPage_leftsib.getCurPage(), true); 
                    }
                    catch (Exception e)
                    {
                        throw new UnpinPageException(e, "UnpinPageException");
                    }
                    try  
                    {
                        Minibase.JavabaseBM.unpinPage(leaf.getCurPage(), true); 
                    }
                    catch (Exception e)
                    {
                        throw new FreePageException(e, "FreePageException");
                    }
                    try  
                    {
                        Minibase.JavabaseBM.freePage(leaf.getCurPage()); 
                    }
                    catch (Exception e)
                    {
                        throw new FreePageException(e, "FreePageException");
                    }
                }
                else  //leaf = only child
                {
                    try  
                    {
                        Minibase.JavabaseBM.unpinPage (leaf.getCurPage(), true); 
                    }
                    catch (Exception e)
                    {
                        throw new FreePageException(e, "FreePageException");
                    }
                    try  
                    {
                        Minibase.JavabaseBM.freePage(leaf.getCurPage()); 
                    }
                    catch (Exception e)
                    {
                        throw new FreePageException(e, "FreePageException");
                    }  
                }               
            }
        }
    }
    
    public PageId find_left_sib(BTIndexPage index, PageId pg) throws IOException, ConstructPageException,
    IteratorException, HashEntryNotFoundException,InvalidFrameNumberException, PageUnpinnedException,
    ReplacerException, KeyNotMatchException, IndexSearchException
    {
        int slots = index.getSlotCnt ();
        KeyEntry[] array = new KeyEntry[slots];
       
        Key key_in_index = find_key(index, pg);
       
        if (key_in_index != null)
        {
            try
            {
                array[0]= index.getFirst(new RID());
            }
            catch(Exception e)
            {
                throw new IteratorException(e, "IteratorException");
            }
           
           
            for (int i = 0; i < slots; i++)
            {
                array[i] = index.getNext(new RID());
            };
           
            boolean found = false;
            int good=0;
            for (int i = 0; (i < slots) && (found == false); i++)
            {
                if (array[i].key.compareTo(key_in_index) == 0)
                {
                    found = true;
                    good = i;
                }           
            }
                   
            if (good == 0)
            {
                return index.getLeftLink();
            }
            else
            {
                try
                {
                    return index.getPageNoByKey(array[good-1].key);
                }
                catch(Exception e)
                {
                    throw new IndexSearchException(e, "IndexSearchException");
                }
            }
        }//if a_key ==null
        else
        {
            return null;
           
        }
    }
	
	public PageId find_right_sib(BTIndexPage index, PageId pg) throws IOException, ConstructPageException,
    IteratorException, HashEntryNotFoundException,InvalidFrameNumberException, PageUnpinnedException,
    ReplacerException, KeyNotMatchException, IndexSearchException
    {

        RID rid = new RID();
       
        int slots = index.getSlotCnt();
        KeyEntry[] array = new KeyEntry[slots];
       
        Key key_in_index = find_key(index, pg);
       
        if (key_in_index != null)
        {       
            try
            {
                array[0] = index.getFirst(new RID());
            }
            catch(Exception e)
            {
                throw new IteratorException(e, "IteratorException");
            }
           
            for (int i = 1; i < slots; i++)
            {
                array[i] = index.getNext(new RID());
            };
           
            boolean found = false;
            int good=0;
            for (int i = 0; (i < slots) && (found == false); i++)
            {
                if (array[i].key.compareTo(key_in_index) == 0)
                {
                    found = true;
                    good = i;
                }           
            }
                   
            if (good == 0)
            {
                return index.getLeftLink();
            }
            else
            {
                if (good == slots-1)
                    return null;
                else
                {
                    try
                    {
                        return index.getPageNoByKey(array[good+1].key);
                    }
                    catch(Exception e)
                    {
                        throw new IndexSearchException(e, "IndexSearchException");
                    }
                }
            }
        }//if a_key ==null
        else
        {
            return null;           
        }       
    }
	
	
	//deletes key from index-pg,
	//will return true if after deletion the pg is less then half the size
	public boolean delete_app_key(Key key, BTIndexPage index_pg)
	{		
		return true;
	}
	


	/**
	 * create a scan with given keys Cases: (1) lo_key = null, hi_key = null
	 * scan the whole index (2) lo_key = null, hi_key!= null range scan from min
	 * to the hi_key (3) lo_key!= null, hi_key = null range scan from the lo_key
	 * to max (4) lo_key!= null, hi_key!= null, lo_key = hi_key exact match (
	 * might not unique) (5) lo_key!= null, hi_key!= null, lo_key < hi_key range
	 * scan from lo_key to hi_key
	 * 
	 * @param lo_key
	 *            the key where we begin scanning. Input parameter.
	 * @param hi_key
	 *            the key where we stop scanning. Input parameter.
	 * @exception IOException
	 *                error from the lower layer
	 * @exception KeyNotMatchException
	 *                key is not integer key nor string key
	 * @exception IteratorException
	 *                iterator error
	 * @exception ConstructPageException
	 *                error in BT page constructor
	 * @exception PinPageException
	 *                error when pin a page
	 * @exception UnpinPageException
	 *                error when unpin a page
	 */
	public BTFileScan new_scan(Key lo_key, Key hi_key)
			throws IOException, KeyNotMatchException, IteratorException,
			ConstructPageException, PinPageException, UnpinPageException
	{
		BTFileScan scanner = new BTFileScan();
		
		if (lo_key.getKeyLength() > hi_key.getKeyLength())
			scanner.maxKeysize = lo_key.getKeyLength();
		else
			scanner.maxKeysize = hi_key.getKeyLength();

		//If the lo_key > hi_key then we can't preform the scan
		if ((lo_key != null && hi_key != null) && lo_key.compareTo(hi_key) > 0)
		{
			System.out.print("Low key is greater than high key\n Can't preform scan!");
			return null;
		}
		
		if (hi_key == null)
			scanner.tilEnd = true;
		scanner.firstTime = true;
		scanner.low = lo_key;
		scanner.high = hi_key;
		scanner.done = false;
		scanner.rid = new RID();
		scanner.myTree = this;
		scanner.delOccured = false;
		scanner.dupKeyCount  = 0;
		
		//Set the first leaf to the starting scan item
		scanner.curLeaf = new BTLeafPage(firstLeaf(lo_key, theHeadPtr.get_rootId()), theHeadPtr.get_keyType());
		
		try{
			scanner.curEntry = scanner.curLeaf.getFirst(scanner.rid);
			scanner.prevEntry = scanner.curEntry;
			
			//If lo_key is null or firstRecord is lo_key then don't move
			if (lo_key == null || scanner.curEntry.key.compareTo(lo_key) == 0)
				;
			else
			{
				//Else keep on searching until u hit that lo_key record
				while (scanner.curEntry.key.compareTo(lo_key) != 0)
				{
					scanner.curEntry = scanner.curLeaf.getNext(scanner.rid);
				}
			}
		}
		catch (Exception e) {throw new ConstructPageException(e, "Error at Leaf page");}
		
		return scanner;
	}


	public void printBTree() throws IOException,
			ConstructPageException, IteratorException,
			HashEntryNotFoundException, InvalidFrameNumberException,
			PageUnpinnedException, ReplacerException
	{
		BTHeaderPage header = getHeaderPage();
		if (header.get_rootId().pid == INVALID_PAGE)
		{
			System.out.println("The Tree is Empty!!!");
			return;
		}

		System.out.println("");
		System.out.println("");
		System.out.println("");
		System.out.println("---------------The B+ Tree Structure---------------");

		System.out.println("header page: " + header.get_rootId());

		_printTree(header.get_rootId(), "", header.get_keyType());

		System.out.println("--------------- End ---------------");
		System.out.println("");
		System.out.println("");
	}

	private void _printTree(PageId currentPageId, String prefix, int keyType) throws IOException, ConstructPageException,
			IteratorException, HashEntryNotFoundException,
			InvalidFrameNumberException, PageUnpinnedException,
			ReplacerException
	{

		BTSortedPage sortedPage = new BTSortedPage(currentPageId, keyType);
		prefix = prefix + "    ";
		
		// for index pages, go through their child pages
		if (sortedPage.getType() == BTSortedPage.INDEX)
		{
			BTIndexPage indexPage = new BTIndexPage((Page) sortedPage, keyType);

			System.out.println(prefix + "index page: " + currentPageId);
			System.out.println(prefix + "  first child: " + 
					indexPage.getPrevPage());
			
			_printTree(indexPage.getPrevPage(), prefix, keyType);

			RID rid = new RID();
			for (KeyEntry entry = indexPage.getFirst(rid); 
				 entry != null;  
				 entry = indexPage.getNext(rid))
			{
				System.out.println(prefix + "  key: " + entry.key + ", page: ");
				_printTree((PageId) entry.getData(), prefix, keyType);
			}
		}
		
		// for leaf pages, iterate through the keys and print them out
		else if (sortedPage.getType() == BTSortedPage.LEAF)
		{
			BTLeafPage leafPage = new BTLeafPage((Page) sortedPage, keyType);
			RID rid = new RID();
			int counter = 0;
			System.out.println(prefix + "leaf page: " + sortedPage);
			for (KeyEntry entry = leafPage.getFirst(rid); 
				 entry != null;  
				 entry = leafPage.getNext(rid), counter++)
			{
				if (counter == 41)
					System.out.println("");
				if (keyType == AttrType.attrInteger)
					System.out.println(prefix + "  ("
							+ entry.key + ",  "
							+ entry.getData() + " )");
				if (keyType == AttrType.attrString)
					System.out.println(prefix + "  ("
							+ entry.key + ",  "
							+ entry.getData() + " )");
			}
		}		
		
		Minibase.JavabaseBM.unpinPage(currentPageId, false/* not dirty */);
	}

}
