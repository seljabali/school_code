package relop;

import global.RID;
import heap.HeapFile;
import heap.HeapScan;

/**
 * <p>CS186 - Spring 2007 - Homework 4: Join Operators</p>
 * <p>Wrapper for heap file scan, the most basic access method. This "iterator"
 * version takes schema into consideration and generates real tuples.</p>
 * <p><b>Note</b>: <code>FileScan</code> is provided to you as a sample iterator
 * implementation. Do not modify it!</p>
 * @version 1.0
 */
public class FileScan extends Iterator
{
	/** The heap file to scan. */
	protected HeapFile file;

	/** The underlying heap scan access method. */
	protected HeapScan scan;

	/** Identifies returned tuples. */
	protected RID rid;

	/** Variable to hold the next tuple to be returned. */
	private Tuple nextTuple;

	// --------------------------------------------------------------------------

	/**
	 * Constructs a file scan, given the schema and heap file.
	 * @param schema The {@link relop.Schema} object that denotes the schema of 
	 * the relation to be scanned.
	 * @param file The {@link heap.HeapFile} object that physically stores the
	 * relation to be scanned on disk.
	 */
	public FileScan(Schema schema, HeapFile file)
	{
		this.schema = schema;
		this.file = file;
		scan = file.openScan();
		rid = new RID();
		this.nextTuple = null;
	}

	/**
	 * Gives a one-line explaination of the iterator, repeats the call on any
	 * child iterators, and increases the indent depth along the way.
	 * @param depth The indentation depth of the output.
	 */
	public void explain(int depth)
	{
		indent(depth);
		System.out.println("FileScan : " + file.toString());
	}

	/**
	 * Restarts the iterator, i.e. as if it were just constructed.
	 */
	public void restart()
	{
		scan.close();
		scan = file.openScan();
	}

	/**
	 * Checks if the iterator is open.
	 * @return <code>true</code> if the iterator is open; <code>false</code> otherwise.
	 */
	public boolean isOpen()
	{
		return (scan != null);
	}

	/**
	 * Closes the iterator, releasing any resources (i.e. temporary fires).
	 */
	public void close()
	{
		if (scan != null)
		{
			scan.close();
			scan = null;
		}
	}

	/**
	 * Checks if there are more tuples available. It is a good practice to 
	 * "precompute" the next available tuple in this function and return it
	 * by a call of {@link #getNext()}. Because this operator is so simple,
	 * you could easily get away with it by simply returning the result of
	 * <code>scan.hasNext()</code>, but as you shall see in the operators you
	 * will implement, you will have to do substantial amount of work in this
	 * function to determine what the next tuple is.
	 * @return <code>true</code> if there are more tuples, <code>false<code> otherwise.
	 */
	public boolean hasNext()
	{
		if(!scan.hasNext())
			return false;
		
		// Convert it into a tuple object.
		this.nextTuple = new Tuple(schema, scan.getNext(rid));
		return true;
	}

	/**
	 * Gets the next tuple in the iteration.
	 * @return The next available {@link relop.Tuple} object of the relation.
	 * @throws IllegalStateException if no more tuples
	 */
	public Tuple getNext()
	{
		return this.nextTuple;
	}

	/**
	 * Gets the RID of the last tuple returned.
	 * @return The {@link global.RID} object of the last tuple returned.
	 */
	public RID getLastRID()
	{
		return new RID(rid);
	}
}
