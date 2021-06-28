package tests;

import global.AttrOperator;
import global.AttrType;
import global.RID;
import global.SearchKey;
import heap.HeapFile;
import index.HashIndex;
import relop.FileScan;
import relop.HashJoin;
import relop.Predicate;
import relop.Projection;
import relop.Schema;
import relop.SimpleJoin;
import relop.Tuple;

/**
 * <p>CS186 - Spring 2007 - Homework 4: Join Operators</p>
 * <p>Test suite for the SimpleJoin and HashJoin operators</p>
 * @version 1.0
 */
class ROTest extends TestDriver 
{
    /** The display name of the test suite. */
	private static final String TEST_NAME = "relational operator tests";

	/** Drivers table schema. */
	private static Schema s_drivers;

	/** Rides table schema. */
	private static Schema s_rides;

	/** Groups table schema. */
	private static Schema s_groups;

	// --------------------------------------------------------------------------

    /**
	 * Create a temporary relation, populate it with values, create a HashIndex
	 * on it, and perform tests on a simple File Scan, an Index Scan and a
	 * Nested Loops self-join.
	 */
    protected boolean test1()
	{
		try
		{
			System.out.println("\nTest 1: Primative relational operators");
			initCounts();
			saveCounts(null);

			// Create and populate a temporary Drivers file and index
			Tuple tuple = new Tuple(s_drivers);
			HeapFile file = new HeapFile(null);
			HashIndex index = new HashIndex(null);
			for (int i = 1; i <= 10; i++)
			{
				// create the tuple
				tuple.setIntFld(0, i);
				tuple.setStringFld(1, "f" + i);
				tuple.setStringFld(2, "l" + i);
				Float age = (float) (i * 7.7);
				tuple.setFloatFld(3, age);
				tuple.setIntFld(4, i + 100);

				// insert the tuple in the file and index
				RID rid = file.insertRecord(tuple.getData());
				index.insertEntry(new SearchKey(age), rid);
			} 
			saveCounts("Insert");

            // Test a file scan
			saveCounts(null);
			System.out.println("\n  ~> Test a file scan...\n");
			FileScan filescan = new FileScan(s_drivers, file);
			filescan.execute();
			saveCounts("FileScan");
			
			// Test the nested-loops join operator, by performing a self-equi-join
			// between attributes 0 and 5. Finally, project the 0th, 1st, 5th and
			// 6th attributes of the result. This is a simple example of operator
			// pipelining.
			saveCounts(null);
			System.out.println("\n  ~> Test simple (nested loops) join...\n");
			Predicate[] preds = new Predicate[]{ new Predicate(AttrOperator.EQ,AttrType.FIELDNO, 0, AttrType.FIELDNO, 5) };
			SimpleJoin join = new SimpleJoin(new FileScan(s_drivers, file),	new FileScan(s_drivers, file), preds);
			Projection pro = new Projection(join, 0, 1, 5, 6);
			pro.execute();

			// Destroy temp files before doing final counts
			join = null;
			pro = null;
			index = null;
			file = null;
			System.gc();
			saveCounts("SimpleJoin");

			System.out.print("\n\nTest 1 completed without exception.");
			return PASS;
		}
		catch (Exception ex)
		{
			ex.printStackTrace(System.out);
			System.out.print("\n\nTest 1 terminated because of exception.");
			return FAIL;
		}
		finally
		{
			printSummary(6);
			System.out.println();
		}
	}

    /**
	 * Test the HashJoin operator. Execute the following query:
	 * SELECT * FROM Drivers D INNER JOIN Rides R ON (D.DriverId = R.DriverId);
	 */
	protected boolean test2()
	{
		try
		{
			System.out.println("\nTest 2: Hash-based join operator\n");
			initCounts();

			// Create and populate the drivers table
			saveCounts(null);
			HeapFile drivers = new HeapFile(null);
			Tuple tuple = new Tuple(s_drivers);
			tuple.setAllFields(1, "Ahmed", "Elmagarmid", 25F, 5);
			tuple.insertIntoFile(drivers);
			tuple.setAllFields(2, "Walid", "Aref", 27F, 13);
			tuple.insertIntoFile(drivers);
			tuple.setAllFields(3, "Christopher", "Clifton", 18F, 4);
			tuple.insertIntoFile(drivers);
			tuple.setAllFields(4, "Sunil", "Prabhakar", 22F, 7);
			tuple.insertIntoFile(drivers);
			tuple.setAllFields(5, "Elisa", "Bertino", 26F, 5);
			tuple.insertIntoFile(drivers);
			tuple.setAllFields(6, "Susanne", "Hambrusch", 23F, 3);
			tuple.insertIntoFile(drivers);
			tuple.setAllFields(7, "David", "Eberts", 24F, 8);
			tuple.insertIntoFile(drivers);
			tuple.setAllFields(8, "Arif", "Ghafoor", 20F, 5);
			tuple.insertIntoFile(drivers);
			tuple.setAllFields(9, "Jeff", "Vitter", 19F, 10);
			tuple.insertIntoFile(drivers);
			saveCounts("drivers");

			// create and populate the rides table
			saveCounts(null);
			HeapFile rides = new HeapFile(null);
			tuple = new Tuple(s_rides);
			tuple.setAllFields(3, 5, "2/10/2006", "2/13/2006");
			tuple.insertIntoFile(rides);
			tuple.setAllFields(1, 2, "2/12/2006", "2/14/2006");
			tuple.insertIntoFile(rides);
			tuple.setAllFields(9, 1, "2/15/2006", "2/15/2006");
			tuple.insertIntoFile(rides);
			tuple.setAllFields(5, 7, "2/14/2006", "2/18/2006");
			tuple.insertIntoFile(rides);
			tuple.setAllFields(1, 3, "2/15/2006", "2/16/2006");
			tuple.insertIntoFile(rides);
			tuple.setAllFields(2, 6, "2/17/2006", "2/20/2006");
			tuple.insertIntoFile(rides);
			tuple.setAllFields(3, 4, "2/18/2006", "2/19/2006");
			tuple.insertIntoFile(rides);
			tuple.setAllFields(4, 1, "2/19/2006", "2/19/2006");
			tuple.insertIntoFile(rides);
			tuple.setAllFields(2, 7, "2/18/2006", "2/23/2006");
			tuple.insertIntoFile(rides);
			tuple.setAllFields(8, 5, "2/20/2006", "2/22/2006");
			tuple.insertIntoFile(rides);
			tuple.setAllFields(3, 2, "2/24/2006", "2/26/2006");
			tuple.insertIntoFile(rides);
			tuple.setAllFields(6, 6, "2/25/2006", "2/26/2006");
			tuple.insertIntoFile(rides);
			saveCounts("rides");

			// Test the hash join operator
			saveCounts(null);
			HashJoin join = new HashJoin(new FileScan(s_drivers, drivers), new FileScan(s_rides, rides), 0, 0);
			join.execute();

			// Destroy temp files before doing final counts
			join = null;
			rides = null;
			drivers = null;
			System.gc();
			saveCounts("HashJoin");

			System.out.print("\n\nTest 2 completed without exception.");
			return PASS;
		}
		catch (Exception ex)
		{
			ex.printStackTrace(System.out);
			System.out.print("\n\nTest 2 terminated because of exception.");
			return FAIL;
		}
		finally
		{
			printSummary(3);
			System.out.println();
		}
	} 
    protected boolean test3()
    {
        try
        {
            System.out.println("\nTest 2: Hash-based join operator\n");
            initCounts();

            // Create and populate the drivers table
            saveCounts(null);
            HeapFile drivers = new HeapFile(null);
            Tuple tuple = new Tuple(s_drivers);
            tuple.setAllFields(1, "Ahmed", "Elmagarmid", 25F, 5);
            tuple.insertIntoFile(drivers);
           
            tuple.setAllFields(1, "Yuly", "Tenorio", 20F, 3);
            tuple.insertIntoFile(drivers);
           
            tuple.setAllFields(2, "Walid", "Aref", 27F, 13);
            tuple.insertIntoFile(drivers);
            tuple.setAllFields(3, "Christopher", "Clifton", 18F, 4);
            tuple.insertIntoFile(drivers);
            tuple.setAllFields(4, "Sunil", "Prabhakar", 22F, 7);
            tuple.insertIntoFile(drivers);
            tuple.setAllFields(5, "Elisa", "Bertino", 26F, 5);
            tuple.insertIntoFile(drivers);
            tuple.setAllFields(6, "Susanne", "Hambrusch", 23F, 3);
            tuple.insertIntoFile(drivers);
            tuple.setAllFields(7, "David", "Eberts", 24F, 8);
            tuple.insertIntoFile(drivers);
            tuple.setAllFields(8, "Arif", "Ghafoor", 20F, 5);
            tuple.insertIntoFile(drivers);
            tuple.setAllFields(9, "Jeff", "Vitter", 19F, 10);
            tuple.insertIntoFile(drivers);
            saveCounts("drivers");

   

            // Test a file scan for HJ 1
            saveCounts(null);
            System.out.println ("\n  ~> Test a file scan 2 ...\n");
            FileScan filescan2 = new FileScan(s_drivers, drivers);
            filescan2.execute();
            saveCounts("FileScan");
           
           

           
                   
            // create and populate the rides table
            saveCounts(null);
            HeapFile rides = new HeapFile(null);
            tuple = new Tuple(s_rides);
            tuple.setAllFields(3, 5, "2/10/2006", "2/13/2006");
            tuple.insertIntoFile(rides);
            tuple.setAllFields(1, 2, "2/12/2006", "2/14/2006");
            tuple.insertIntoFile(rides);
            tuple.setAllFields(9, 1, "2/15/2006", "2/15/2006");
            tuple.insertIntoFile(rides);
            tuple.setAllFields(5, 7, "2/14/2006", "2/18/2006");
            tuple.insertIntoFile(rides);
            tuple.setAllFields(1, 3, "2/15/2006", "2/16/2006");
            tuple.insertIntoFile(rides);
            tuple.setAllFields(2, 6, "2/17/2006", "2/20/2006");
            tuple.insertIntoFile(rides);
            tuple.setAllFields(3, 4, "2/18/2006", "2/19/2006");
            tuple.insertIntoFile(rides);
            tuple.setAllFields(4, 1, "2/19/2006", "2/19/2006");
            tuple.insertIntoFile(rides);
            tuple.setAllFields(2, 7, "2/18/2006", "2/23/2006");
            tuple.insertIntoFile(rides);
            tuple.setAllFields(8, 5, "2/20/2006", "2/22/2006");
            tuple.insertIntoFile(rides);
            tuple.setAllFields(3, 2, "2/24/2006", "2/26/2006");
            tuple.insertIntoFile(rides);
            tuple.setAllFields(6, 6, "2/25/2006", "2/26/2006");
            tuple.insertIntoFile(rides);
            saveCounts("rides");

            //Test a file scan for HJ, 2
            saveCounts(null);
            System.out.println("\n  ~> Test a file scan 3 ...\n Outer Relation: Drivers \t Inner Realtion: Rides \n");
            FileScan filescan3 = new FileScan(s_rides, rides);
            filescan3.execute();
            saveCounts("FileScan");
           
            // Test the hash join operator
            System.out.println("\n  ~> Test a hash join ...\n");
            saveCounts(null);
            //HashJoin join = new HashJoin(new Projection(new FileScan(s_drivers, drivers), 0, 1), new FileScan(s_rides, rides), 0, 0);
            HashJoin join = new HashJoin(new Projection(new FileScan(s_rides, drivers), 0, 2), new FileScan(s_drivers, rides), 0, 0);
            //HashJoin join = new HashJoin(new FileScan(s_drivers, drivers), new FileScan(s_rides, rides), 0, 0);
            //HashJoin join = new HashJoin(new FileScan(s_drivers, drivers), new Projection(new FileScan(s_rides, rides), 0), 0, 0);
            join.execute();
            //HashJoin join2 = new HashJoin(new FileScan(s_drivers, drivers), join, 0, 0);
            //join2.execute();

            // Destroy temp files before doing final counts
            join = null;
            rides = null;
            drivers = null;
            System.gc();
            saveCounts("HashJoin");

            System.out.print("\n\nTest 2 completed without exception.");
            return PASS;
        }
        catch (Exception ex)
        {
            ex.printStackTrace(System.out );
            System.out.print("\n\nTest 2 terminated because of exception.");
            return FAIL;
        }
        finally
        {
            printSummary(3);
            System.out.println ();
        }
    } 
	
    /**
	 * Test application entry point; runs all tests.
	 */
	public static void main(String argv[])
	{
		// Create a clean Minibase instance
		ROTest rot = new ROTest();
		rot.create_minibase();

		// Initialize schema for the "Drivers" table
		s_drivers = new Schema(5);
		s_drivers.initField(0, AttrType.INTEGER, 4, "DriverId");
		s_drivers.initField(1, AttrType.STRING, 20, "FirstName");
		s_drivers.initField(2, AttrType.STRING, 20, "LastName");
		s_drivers.initField(3, AttrType.FLOAT, 4, "Age");
		s_drivers.initField(4, AttrType.INTEGER, 4, "NumSeats");

		// Initialize schema for the "Rides" table
		s_rides = new Schema(4);
		s_rides.initField(0, AttrType.INTEGER, 4, "DriverId");
		s_rides.initField(1, AttrType.INTEGER, 4, "GroupId");
		s_rides.initField(2, AttrType.STRING, 10, "FromDate");
		s_rides.initField(3, AttrType.STRING, 10, "ToDate");

		// Initialize schema for the "Groups" table
		s_groups = new Schema(2);
		s_groups.initField(0, AttrType.INTEGER, 4, "GroupId");
		s_groups.initField(1, AttrType.STRING, 10, "Country");

		// Run all the test cases
		System.out.println("\n" + "Running " + TEST_NAME + "...");
		boolean status = PASS;
		//status &= rot.test1();
		//status &= rot.test2();
		status &= rot.test3();

		// Display the final results
		System.out.println();
		if (status != PASS)
		{
			System.out.println("Error(s) encountered during " + TEST_NAME + ".");
		}
		else
		{
			System.out.println("All " + TEST_NAME + " completed; verify output for correctness.");
		}
	}
}
