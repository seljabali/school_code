package btree;

import exceptions.AddFileEntryException;
import exceptions.ConstructPageException;
import exceptions.GetFileEntryException;
import exceptions.HashEntryNotFoundException;
import exceptions.InvalidFrameNumberException;
import exceptions.PageUnpinnedException;
import exceptions.ReplacerException;
import global.AttrType;
import global.GlobalConst;
import global.Minibase;
import global.PageId;
import global.RID;
import global.TestDriver;

import index.Key;
import index.KeyEntry;

import java.io.BufferedReader;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.FileReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.io.PrintStream;
import java.util.Random;

import bufmgr.BufMgr;

/**
 * Note that in JAVA, methods can't be overridden to be more private. Therefore,
 * the declaration of all private functions are now declared protected as
 * opposed to the private type in C++.
 */

// watching point: RID rid, some of them may not have to be newed.
public class BTTest extends TestDriver implements GlobalConst
{

	public BTreeFile file;

	public int postfix = 0;

	public int keyType;

	public BTFileScan scan;

	public int deleteFashion;

	
	public BTTest()
	{
		super("BTree ");
	}
	
	public void initBeforeTests()
	{
		Random random = new Random();
		dbpath = "BTREE" + random.nextInt() + ".minibase-db";
		logpath = "BTREE" + random.nextInt() + ".minibase-log";

		try {
			Minibase.initBufMgr(new BufMgr(50,"bufmgr.Clock"));
		} catch(Exception ire)
		{
			ire.printStackTrace();
			System.exit(1);
		}
		
		Minibase.initDiskMgr(dbpath, 5000);

		System.out.println("\n" + "Running BTree tests...." + "\n");

		keyType = AttrType.attrInteger;
	}
	
	
	public boolean test1() throws IOException
	{
		BTreeFile newIndex = null;
		int counter = 0;
		try
		{
			newIndex = new BTreeFile("test",keyType,4,0);
			//
			PageId aPg = newIndex.getHeaderPage().get_rootId();
		
			BufferedReader br = new BufferedReader(new FileReader("C:\\Documents and Settings\\Sami\\My Documents\\Programming\\CS186\\Yuly_Hw2\\100keysInsertOnlyNoDups.txt"));
			String line = null;
			RID dummy = new RID();
			while ((line = br.readLine()) != null)
			{
				//if (counter == 40)
					//System.out.println("");
				//System.out.println("Processing line: " + line);
				switch (line.charAt(0))
				{
				case 'i':
					newIndex.insert(new Key(Integer.parseInt(line.substring(1))), dummy);
					aPg = newIndex.getHeaderPage().get_rootId();
					break;
					
				case 'd':
					newIndex.delete(new Key(Integer.parseInt(line.substring(1))), dummy);
					break;
					
					
				case 'p':
					newIndex.printBTree();
					break;
					
				default:  
					System.out.println("Unable to parse line: " + line);
				}
				counter++;
			}

			try{
			    KeyEntry next;

			    
			    for (int i=0 ; i<Minibase.JavabaseBM.getFrameTable().length ; i++) 
			    {
					System.
					out.println("i = " + i +", PageId = " + Minibase.JavabaseBM.getFrameTable()[i].getPageNo() 
								+ ", pincount = " + Minibase.JavabaseBM.getFrameTable()[i].getPinCount());
				}			
			    

			    BTFileScan scan = newIndex.new_scan(new Key(1), new Key(89));
			    counter = 0;
			    		    
			   // while ((next = scan.get_next()) != null)
			   // {		
			   // 	System.out.println(next.key.getKey());
			   // }
			   //next = scan.get_next();
			    //System.out.println(next.key.getKey());
			    for (int i = 0; i< 30; i++)
			    {
			    	if (i == 40)
			    		System.out.print("");
			    	next = scan.get_next();			    	
			    	scan.delete_current();
			    }
			    newIndex.printBTree();
			    //System.out.println(next.key.getKey());
			    //next = scan.get_next();
			    //System.out.println(next.key.getKey());
			    
			    for (int i=0 ; i<Minibase.JavabaseBM.getFrameTable().length ; i++) 
			    {
					System.
					out.println("i = " + i +", PageId = " + Minibase.JavabaseBM.getFrameTable()[i].getPageNo() + ", pincount = " + Minibase.JavabaseBM.getFrameTable()[i].getPinCount());
				}
    
			}
			catch (Exception e){
				throw new IOException("Error making new scan");
			}
			
		} 
		catch (Exception e)
		{
			e.printStackTrace();
			return(false);
		}
		
		try
		{
			newIndex.close();
			newIndex.destroyFile();
		} catch (Exception e)
		{
			e.printStackTrace();
			return(false);
		}
		
		return(true);
	}

	public static void createFile(String name, int numKeys, boolean doDelete, 
			boolean allowDups)
	{
		PrintStream ps = null;
		Random rand = new Random(System.currentTimeMillis());
		
		try
		{
			int written[] = new int[numKeys];
			int numWritten = 0;
			ps = new PrintStream(new FileOutputStream(name));
			
			// if we're in non-mixed mode, insert all nums, then delete all.			
			// insert a random key
			while (numWritten < numKeys)
			{
				int keyVal = (int)Math.round(rand.nextDouble() * (numKeys - 1));
				if ((written[keyVal]==0) || allowDups)
				{
					ps.println("i"+keyVal);
					written[keyVal]++;
					numWritten++;
				}
			}

			// print the whole tree
			ps.println("p");

			// now delete all keys
			if (doDelete) while (numWritten > 0)
			{
				int keyVal = (int)Math.round(rand.nextDouble() * (numKeys - 1));
				if (written[keyVal]>0) 
				{
					ps.println("d"+keyVal);
					written[keyVal]--;
					numWritten--;   
				}
			}

			// print the whole tree
			ps.println("p");
		} 
		catch (Exception e)
		{
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		ps.close();
	}
	
	
	public static void main(String[] argvs)
	{	
		try
		{
			BTTest bttest = new BTTest();
			bttest.runTests();
		} catch (Exception e)
		{
			e.printStackTrace();
			System.out.println("Error encountered during BTree tests:\n");
			Runtime.getRuntime().exit(1);
		}
	}	
}