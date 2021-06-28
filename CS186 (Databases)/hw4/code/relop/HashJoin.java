package relop;
import index.HashIndex;
import global.SearchKey;
import global.*;
import heap.HeapFile;
import java.lang.Object;
import relop.IndexScan;

/**
 * <p>CS186 - Spring 2007 - Homework 4: Join Operators</p>
 * <p>Implement the hash-based join algorithm described in section 14.4.3 of the
 * textbook (3rd edition; see pages 463 to 464). Use {@link index.HashIndex}
 * to partition the tuples into buckets during the partitoning phase,
 * {@link relop.IndexScan} to scan through the tuples resinding in the partitions
 * generated during the first phase, and {@link relop.HashTableDup} to store a
 * partition in memory during the matching phase of the algorithm. <b>Do not</b>
 * concern yourselves about any memory requirements and handling partition
 * overflows. Assume that every partiton that gets created in the partitioning
 * phase will fit in memory during the second phase.</p>
 * @version 1.0
 */
public class HashJoin extends Iterator
{
	private Iterator initLeft, initRight;
	private HashIndex HashIndexR, HashIndexL;
	private IndexScan IndexScanR, IndexScanL;
	private HeapFile HeapFileR, HeapFileL;
	private HashTableDup HashDup;
	private boolean areDuplicates;
	private Tuple TupleNext[];
	private Integer ColumnR, ColumnL;
	private int numDuplicates;

	public HashJoin(Iterator left, Iterator right, Integer lcol, Integer rcol)
	{
		Iterator IteratorL, IteratorR;
		ColumnR = rcol;
		ColumnL = lcol;
		left.restart();
		right.restart();

		this.schema = schema.join(left.schema, right.schema);

		IteratorL = left;
		IteratorR = right;
		initLeft = left;
		initRight = right;
		Tuple tuple;

		//Partioning
		if (!(IteratorL instanceof IndexScan))
		{
			this.HashIndexL = new HashIndex(null);
			this.HeapFileL = new HeapFile(null);
			if (IteratorL instanceof FileScan) //if it is a filescan
			{
				FileScan file = (FileScan)IteratorL;
				while (file.hasNext())
				{
					tuple = file.getNext();
					HashIndexL.insertEntry(new SearchKey(tuple.getField(lcol)), file.getLastRID());
				}
				this.IndexScanL = new IndexScan(IteratorL.schema, HashIndexL, file.file);
				//**Change**//
				IteratorL.restart();
				//****//
				file.close();
				file = null;
			}
			else //Niether filescan or IndexScan
			{
				while (IteratorL.hasNext())
				{
					tuple = IteratorL.getNext();
					//RID rid =  new RID(HeapFileL.insertRecord(tuple.getData()));
					RID rid =  tuple.insertIntoFile(HeapFileL);
					Object key = tuple.getField(lcol);
					SearchKey HashKey = new global.SearchKey(key);
					HashIndexL.insertEntry(HashKey, rid);
				}
				this.IndexScanL = new IndexScan(IteratorL.schema, HashIndexL, HeapFileL);
				//***Change***//
				IteratorL.restart();
				//*****//
			}
		}
		else
		{
			this.IndexScanL = (IndexScan)IteratorL; //its an index scan
			IteratorL.close();
			IteratorL = null;
		}

		if (!(IteratorR instanceof IndexScan))
		{
			this.HashIndexR = new HashIndex(null);
			this.HeapFileR = new HeapFile(null);
			if (IteratorR instanceof FileScan) //if it is a filescan
			{
				FileScan file = (FileScan)IteratorR;
				while (file.hasNext())
				{
					tuple = file.getNext();
					HashIndexR.insertEntry(new SearchKey(tuple.getField(rcol)), file.getLastRID());
				}
				this.IndexScanR = new IndexScan(IteratorR.schema, HashIndexR, file.file);

				//***Change****//
				IteratorR.restart();
				//*****//

				file.close();
				file = null;
			}
			else //Niether filescan or IndexScan
			{
				while (IteratorR.hasNext())
				{
					tuple = IteratorR.getNext();
					//RID rid =  new RID(HeapFileL.insertRecord(tuple.getData()));
					RID ridR =  tuple.insertIntoFile(HeapFileR);
					Object keyR = tuple.getField(rcol);
					SearchKey HashKeyR = new global.SearchKey(keyR);
					HashIndexR.insertEntry(HashKeyR, ridR);
				}
				this.IndexScanR = new IndexScan(IteratorR.schema, HashIndexR, HeapFileR);

				//***Change***//
				IteratorR.restart();
				//***//
			}
		}
		else
		{
			this.IndexScanR = (IndexScan)IteratorR; //its an index scan
			IteratorL.close();
			IteratorL = null;
		}

		IndexScanL.restart();
		IndexScanR.restart();
	}

	/**
	 * Checks if there are more tuples available. It is a good practice to
	 * "precompute" the next available tuple in this function and return it
	 * by a call of {@link #getNext()}.
	 * @return <code>true</code> if there are more tuples, <code>false<code> otherwise.
	 */
	public boolean hasNext()
	{
		Tuple TupleRight = null, TupleLeft[] = null;
		int curHashR = IndexScanR.getNextHash();
		boolean firstTime = true;

		if(areDuplicates)
			return true;

		while (IndexScanR.hasNext())
		{
			while ((curHashR == IndexScanR.getNextHash()) && IndexScanR.hasNext())
			{
				if (firstTime) //if we are at a new Hash value
				{
					firstTime = false;
					_FillHashDup(curHashR); //Construct the HashDupTable
				}
				TupleRight = IndexScanR.getNext();

				TupleLeft = HashDup.getAll(new SearchKey(TupleRight.getField(ColumnR))); //find all matching tuples
				if (TupleLeft == null)
					break;
				if (TupleLeft.length > 0)//if there are results
				{
					for (int i = 0; i < TupleLeft.length; i++)
						TupleLeft[i] = Tuple.join(TupleLeft[i], TupleRight, this.schema); //Store them in an array
					TupleNext = TupleLeft;
					if (TupleLeft.length > 1) //if there is more than one then set flags for getNext
					{
						areDuplicates = true;
						numDuplicates = TupleLeft.length - 1;
					}
					return true;
				}

			}
			curHashR = IndexScanR.getNextHash(); //Get next hash bucket
			TupleRight = IndexScanR.getNext();
			firstTime = true;
		}
		TupleNext = null; //!!May cause NullPionter Exception!!
		return false;
	}

	//Constructing the HashDupTable
	private void _FillHashDup(int HashRight)
	{
		HashDup = new HashTableDup();
		Tuple TupleLeft = null;
		IndexScanL.restart();
		boolean beenThere = false;

		//if we are not at the right bucket then keep iterating until u do
		if ((IndexScanL.getNextHash() != HashRight))
		{
			while (IndexScanL.hasNext() && (IndexScanL.getNextHash() != HashRight))
				TupleLeft = IndexScanL.getNext();
			beenThere = true;
		}

		//If we reached the right bucket
		while(IndexScanL.hasNext() && (IndexScanL.getNextHash() == HashRight))
		{
			if (beenThere)//If we already obtained the first element from before
			{
				HashDup.add(new SearchKey(TupleLeft.getField(ColumnL)), TupleLeft);
				beenThere = false;
			}
			else
			{
				TupleLeft = IndexScanL.getNext();
				HashDup.add(new SearchKey(TupleLeft.getField(ColumnL)), TupleLeft);
			}
		}
	}
	/**
	 * Gets the next tuple in the iteration.
	 * @return The next available {@link relop.Tuple} object of the relation.
	 * @throws IllegalStateException if no more tuples
	 */
	public Tuple getNext()
	{
	//	if (hasNext())
		//{
			if (areDuplicates)
			{
				if (numDuplicates == 0)
				{
					areDuplicates = false;
				}
				//numDuplicates--;
				return TupleNext[numDuplicates--];
			}
			else
				return TupleNext[0]; //might be null
	//	//}
		//else
			//return null;

	}
	/**
	 * Gives a one-line explaination of the iterator, repeats the call on any
	 * child iterators, and increases the indent depth along the way.
	 * @param depth The indentation depth of the output.
	 */
	public void explain(int depth)
	{
		indent(depth);
		System.out.println("HashJoin: \t");
		IndexScanL.explain(depth +1);
		IndexScanR.explain(depth +1);
	}

	/**
	 * Restarts the iterator, i.e. as if it were just constructed.
	 */
	public void restart()
	{
		if (IndexScanL != null)
			IndexScanL.restart();
		if (IndexScanR != null)
			IndexScanR.restart();

/**COMMENT THIS OUT
		Iterator IteratorL, IteratorR;
		//left.restart();
		//right.restart();

		IteratorL = initLeft;
		IteratorR = initRight;
		Tuple tuple;

		//Partioning
		if (!(IteratorL instanceof IndexScan))
		{
			this.HashIndexL = new HashIndex(null);
			this.HeapFileL = new HeapFile(null);
			if (IteratorL instanceof FileScan) //if it is a filescan
			{
				FileScan file = (FileScan)IteratorL;
				while (IteratorL.hasNext())
				{
					tuple = file.getNext();
					HashIndexL.insertEntry(new SearchKey(tuple.getField(ColumnL)), file.getLastRID());
				}
				this.IndexScanL = new IndexScan(IteratorL.schema, HashIndexL, file.file);
				file.close();
				file = null;
			}
			else //Niether filescan or IndexScan
			{
				while (IteratorL.hasNext())
				{
					tuple = IteratorL.getNext();
					//RID rid =  new RID(HeapFileL.insertRecord(tuple.getData()));
					RID rid =  tuple.insertIntoFile(HeapFileL);
					Object key = tuple.getField(ColumnL);
					SearchKey HashKey = new global.SearchKey(key);
					HashIndexL.insertEntry(HashKey, rid);
				}
				this.IndexScanL = new IndexScan(IteratorL.schema, HashIndexL, HeapFileL);
			}
		}
		else
		{
			this.IndexScanL = (IndexScan)IteratorL; //its an index scan
			IteratorL.close();
			IteratorL = null;
		}

		if (!(IteratorR instanceof IndexScan))
		{
			this.HashIndexR = new HashIndex(null);
			this.HeapFileR = new HeapFile(null);
			if (IteratorR instanceof FileScan) //if it is a filescan
			{
				FileScan file = (FileScan)IteratorR;
				while (file.hasNext())
				{
					tuple = file.getNext();
					HashIndexR.insertEntry(new SearchKey(tuple.getField(ColumnR)), file.getLastRID());
				}
				this.IndexScanR = new IndexScan(IteratorR.schema, HashIndexR, file.file);
				file.close();
				file = null;
			}
			else //Niether filescan or IndexScan
			{
				while (IteratorR.hasNext())
				{
					tuple = IteratorR.getNext();
					//RID rid =  new RID(HeapFileL.insertRecord(tuple.getData()));
					RID ridR =  tuple.insertIntoFile(HeapFileR);
					Object keyR = tuple.getField(ColumnR);
					SearchKey HashKeyR = new global.SearchKey(keyR);
					HashIndexR.insertEntry(HashKeyR, ridR);
				}
				this.IndexScanR = new IndexScan(IteratorR.schema, HashIndexR, HeapFileR);
			}
		}
		else
		{
			this.IndexScanR = (IndexScan)IteratorR; //its an index scan
			IteratorL.close();
			IteratorL = null;
		}

		IndexScanL.restart();
		IndexScanR.restart();   *****/
	}
	/**
	 * Checks if the iterator is open.
	 * @return <code>true</code> if the iterator is open; <code>false</code> otherwise.
	 */
	public boolean isOpen()
	{
		if (IndexScanL.isOpen() && IndexScanR.isOpen())
			return true;
		else
			return false;
	}

	/**
	 * Closes the iterator, releasing any resources (i.e. temporary fires).
	 */
	public void close()
	{
		if (isOpen())
		{
			IndexScanR.close();
			IndexScanL.close();
			IndexScanL = null;
			IndexScanR = null;
			HashDup.clear();
			HashDup = null;
			HashIndexL.deleteFile();
			HashIndexL = null;
			HashIndexR.deleteFile();
			HashIndexR = null;
		}
	}
}
