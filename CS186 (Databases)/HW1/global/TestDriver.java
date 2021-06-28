package global;

import java.io.File;
import java.io.IOException;
import java.lang.reflect.InvocationTargetException;
import java.lang.reflect.Method;
import java.util.Arrays;
import java.util.Comparator;
import java.util.Iterator;
import java.util.TreeSet;


import exceptions.ChainException;

/**
 * TestDriver class is a base class for various test driver objects. <br>
 * Note that the code written so far is very machine dependent. It assumes the
 * users are on UNIX system. For example, in function runTests, a UNIX command
 * is called to clean up the working directories.
 * 
 */

public abstract class TestDriver
{

	public final static boolean OK = true;

	public final static boolean FAIL = false;
	
	protected String testName="No op";

	protected String dbpath;

	protected String logpath;
	
	

	/**
	 * TestDriver Constructor
	 * 
	 * @param nameRoot
	 *            The name of the test being run
	 */

	public TestDriver(String nameRoot)
	{

		testName = nameRoot;
		
		// To port it to a different platform, get "user.name" should
		// still work well because this feature is not meant to be UNIX
		// dependent.
		dbpath = "/tmp/" + nameRoot + System.getProperty("user.name")
				+ ".minibase-db";
		logpath = "/tmp/" + nameRoot + System.getProperty("user.name")
				+ ".minibase-log";
	}

	/**
	 * Another Constructor
	 */

	protected TestDriver()
	{
	}

	/**
	 * @return <code>String</code> object which contains the name of the test
	 */
	public  String testName()
	{
		return testName;
	}
	

	/**
	 * initBeforeTests
	 *
	 * Starts the buffer manager.
	 * 
	 * Subclasses should override this method with any initialization needed 
	 * before running all tests.
	 */
	public void initBeforeTests() {}

	/**
	 * cleanupAfterTests
	 *
	 * subclasses should override this method with any cleanup needed 
	 * after running all tests.
	 */
	public void cleanupAfterTests() 
	{
		System.out.println("Cleaning up ...");
		try
		{
			Minibase.JavabaseDB.DBDestroy();

		} catch (IOException e)
		{
			System.out.println(" DB already destroyed");
			e.printStackTrace();
		}
	}

 	/**
	 * This function does the preparation/cleaning work for the running tests.
	 * 
	 * @return a boolean value indicates whether ALL the tests have passed
	 */
	public final boolean runTests()
	{

		System.out
				.println("\n" + "Running " + testName() + " tests...." + "\n");
		
		// init
		initBeforeTests();

		// Kill anything that might be hanging around
		String newdbpath;
		String newlogpath;

		newdbpath = dbpath;
		newlogpath = logpath;

		// Commands here is very machine dependent. We assume
		// user are on UNIX system here
		try
		{
			if (logpath != null)
				new File(logpath).delete();
			if (dbpath != null)
				new File(dbpath).delete();
		} catch (Exception e)
		{
			System.err.println("" + e);
			e.printStackTrace();
		}

		// This step seems redundant for me. But it's in the original
		// C++ code. So I am keeping it as of now, just in case I
		// I missed something
		try
		{
			if (newlogpath != null)
				new File(newlogpath).delete();
			if (newdbpath != null)
				new File(newdbpath).delete();
		} catch (Exception e)
		{
			System.err.println("" + e);
			e.printStackTrace();
		}

		// Run the tests. Return type different from C++
		boolean _pass = runAllTests();

		// Clean up again
		try
		{
			if (newlogpath != null)
				new File(newlogpath).delete();
			if (newdbpath != null)
				new File(newdbpath).delete();
		} catch (Exception e)
		{
			System.err.println("" + e);
			e.printStackTrace();
		}

		System.out.print("\n..." + testName() + " tests ");
		System.out.print(_pass == OK ? "completed successfully" : "failed");
		System.out.println(".\n\n");

		cleanupAfterTests();
		
		return _pass;
	}
	
	/**
	 * runAllTests
	 * 
	 * This method uses reflection to run all methods with the signature:
	 * 
	 * boolean test<num>()
	 * 
	 * If any tests fails, it returns false, otherwise it returns true.
	 * 
	 * @return whether or not all the tests ran successfully
	 */

	protected final boolean runAllTests()
	{
		Method[] methods = this.getClass().getDeclaredMethods();
		
		// our convention will be to run the test methods in alphabetical order
		// this tree set should hold the ones we want in order
		TreeSet sortedMethods = new TreeSet(new Comparator() {
			public int compare(Object o1, Object o2)
			{
				if (o1 instanceof Method && o2 instanceof Method)
					return(((Method)o1).getName().compareTo(((Method)o2).getName()));
				else
					return(-1);
			}});

		sortedMethods.addAll(Arrays.asList(methods));
		
		for (Iterator i = sortedMethods.iterator(); i.hasNext();)
		{
			Method m = (Method)i.next();
			if ((m.getReturnType().equals(boolean.class)) &&
				 m.getParameterTypes().length == 0 &&
				 m.getName().startsWith("test"))
				try
				{
					System.out.println("\n Invoking test: " + m.getName());
					Object res = m.invoke(this,null);
					if ((res instanceof Boolean) &&
						((Boolean)res).booleanValue())
						continue;
					else
						return(false);
				} catch (InvocationTargetException e)
				{
					e.getTargetException().printStackTrace();
					return(false);
				}
				catch (Exception e)
				{
					e.printStackTrace();
					return(false);
				}
		}
		
		return(true);
	}


	/**
	 * Used to verify whether the exception thrown from the bottom layer is the
	 * one expected.
	 */
	public boolean checkException(ChainException e, Class expectedException)
	{
		boolean notCaught = true;
		while (true)
		{

			// if we see the expected exception, status is false
			if (expectedException.isAssignableFrom(e.getClass()))
			{
				return (false);
			}

			if (e.prev == null)
			{
				return true;
			}
			e = (ChainException) e.prev;
		}

	} // end of checkException
	
//	public static void main(String argv[])
//	{
//
//		TestDriver testDriver = new TestDriver("TestDriver");
//		
//		boolean dbstatus=false;
//
//		dbstatus = testDriver.runTests();
//
//		if (dbstatus != true)
//		{
//			System.out
//					.println("Error encountered during buffer manager tests:\n");
//			System.out.flush();
//			Runtime.getRuntime().exit(1);
//		}
//
//		Runtime.getRuntime().exit(0);
//	}

} // end of TestDriver
