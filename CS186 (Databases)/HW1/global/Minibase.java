package global;

import diskmgr.*;
import catalog.*;

public class Minibase
{
	// Buffer Manager
	public static AbstractBufMgr JavabaseBM    = null;

	// Disk Manager
	public static DB JavabaseDB                = null;
	public static String JavabaseDBName        = null;
	public static String JavabaseLogName       = null;

	// Catalog
	public static Catalog JavabaseCatalog      = null;
	public static Catalog MINIBASE_CATALOGPTR  = null;
	public static AttrCatalog MINIBASE_ATTRCAT = null;
	public static RelCatalog MINIBASE_RELCAT   = null;
	public static IndexCatalog MINIBASE_INDCAT = null;

	
	public static void initBufMgr(AbstractBufMgr bMgr)
	{
		JavabaseBM = bMgr;
	}


	public static void initDiskMgr(String dbname, int num_pgs)
	{
		try
		{
			JavabaseDB = new DB();
		} catch (Exception e)
		{
			System.err.println("" + e);
			e.printStackTrace();
			Runtime.getRuntime().exit(1);
		}

		JavabaseDBName = new String(dbname);
		JavabaseLogName = new String(dbname);

		// create or open the DB

		if (num_pgs == 0) // open an existing database
		{
			try
			{
				JavabaseDB.openDB(dbname);
			} catch (Exception e)
			{
				System.out.println("" + e);
				e.printStackTrace();
				Runtime.getRuntime().exit(1);
			}
		} else
		{
			try
			{
				JavabaseDB.openDB(dbname, num_pgs);
				JavabaseBM.flushAllPages();
			} catch (Exception e)
			{
				System.out.println("" + e);
				e.printStackTrace();
				Runtime.getRuntime().exit(1);
			}
		}
	}
	
/*	public static void initSystemDefs(String dbname, int num_pgs,
			int bufpoolsize, String replacement_policy)
	{
		int logsize;

		if (num_pgs == 0)
		{
			logsize = 500;
		} else
		{
			logsize = 3 * num_pgs;
		}

		if (replacement_policy == null)
		{
			replacement_policy = new String("Clock");
		}

		// boolean status = true;
		JavabaseBM = null;
		JavabaseDB = null;
		JavabaseDBName = null;
		JavabaseLogName = null;
		JavabaseCatalog = null;

		try
		{
			JavabaseBM = AbstractBufMgr.createBufMgr(bufpoolsize, replacement_policy);
			JavabaseDB = new DB();
			
			 * JavabaseCatalog = new Catalog();
			 
		} catch (Exception e)
		{
			System.err.println("" + e);
			e.printStackTrace();
			Runtime.getRuntime().exit(1);
		}

		JavabaseDBName = new String(dbname);
		JavabaseLogName = new String(dbname);

		// create or open the DB

		if (num_pgs == 0) // open an existing database
		{
			try
			{
				JavabaseDB.openDB(dbname);
			} catch (Exception e)
			{
				System.out.println("" + e);
				e.printStackTrace();
				Runtime.getRuntime().exit(1);
			}
		} else
		{
			try
			{
				JavabaseDB.openDB(dbname, num_pgs);
				JavabaseBM.flushAllPages();
			} catch (Exception e)
			{
				System.out.println("" + e);
				e.printStackTrace();
				Runtime.getRuntime().exit(1);
			}
		}
	}
*/	
	
	//
	// constants for dealing with Catalogs
	//
	
	public static void initCatalog(int initCatalog)
	{

		JavabaseCatalog = new Catalog();

		MINIBASE_CATALOGPTR = Minibase.JavabaseCatalog;
		MINIBASE_ATTRCAT = MINIBASE_CATALOGPTR.getAttrCat();
		MINIBASE_RELCAT = MINIBASE_CATALOGPTR.getRelCat();
		MINIBASE_INDCAT = MINIBASE_CATALOGPTR.getIndCat();
	}
	
	
	// obsolete stuff
	
	//public static boolean MINIBASE_RESTART_FLAG = false;	

}
