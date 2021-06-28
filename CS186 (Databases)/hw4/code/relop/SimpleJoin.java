package relop;

/**
 * <p>CS186 - Spring 2007 - Homework 4: Join Operators</p>
 * <p>Implement the simplest of all join algorithms: nested loops (see textbook, 3rd edition,
 * section 14.4.1, page 454).</p>
 * @version 1.0
 */
public class SimpleJoin extends Iterator
{
	public Iterator leftIt;
	public Iterator rightIt;
	public Predicate[] predicts;
	private Tuple nLeftTup, nRightTup;
	private Tuple nextTuple;
	private Boolean openFlag;
	private boolean next_exists;
	private boolean preds_valid = true;
	
	/**
	 * Constructs a join, given the left and right iterators and join predicates
	 * (relative to the combined schema).
	 * @param left The {@link relop.Iterator} object corresponding to the left 
	 * input of the join.
	 * @param right The {@link relop.Iterator} object corresponding to the right 
	 * input of the join.
	 * @param preds An array of {@link relop.Predicate} objects, corresponding to
	 * the predicates on which the join is performed. If for example you are joining
	 * relations R and S under the condition (R.attr1 > S.attr2 && R.attr3 = S.attr4),
	 * you have to pass as an argument an array of two {@link relop.Predicate} objects,
	 * instantiated according to the above conditions. 
	 */
	public SimpleJoin(Iterator left, Iterator right, Predicate[] preds)
	{	
		leftIt = left;
		leftIt.restart();
		if (leftIt.hasNext())
		{
			nLeftTup=leftIt.getNext();
		}
		
		rightIt = right;
		rightIt.restart();
		
		predicts = preds;
		openFlag = true;
		next_exists = false;	
		this.nextTuple = null;
		
		this.schema = schema.join(leftIt.schema, rightIt.schema);	
				
		for (int i=0; i<=preds.length - 1; i++)
		{
			if (! (preds[i].validate(this.schema)))
				preds_valid = false;
		}
	}

	/**
	 * Gives a one-line explaination of the iterator, repeats the call on any
	 * child iterators, and increases the indent depth along the way.
	 * @param depth The indentation depth of the output.
	 */
	public void explain(int depth)
	{	
		
		indent(depth);
		System.out.println("Nested Simple Join of: " + "\n");  
		leftIt.explain(depth+1);
		rightIt.explain(depth+1);
	}

	/**
	 * Restarts the iterator, i.e. as if it were just constructed.
	 */
	public void restart()
	{		
		this.open();
		
		openFlag = true;
	}

	public void open()
	{	
		if (leftIt != null && rightIt != null)
		{
			leftIt.restart();
			leftIt.hasNext();		
			nLeftTup = leftIt.getNext();		
			
			rightIt.restart();		
			
			openFlag = true;
		}
	}
	
	/**
	 * Checks if the iterator is open.
	 * @return <code>true</code> if the iterator is open; <code>false</code> otherwise.
	 */
	public boolean isOpen()
	{
		return openFlag;
	}

	/**
	 * Closes the iterator, releasing any resources (i.e. temporary fires).
	 */
	public void close()
	{
		if (openFlag != false)
		{
			leftIt.close();
			leftIt = null;
			
			rightIt.close();	
			rightIt = null;
			
			openFlag = false;
		}		
	}

	/**
	 * Checks if there are more tuples available. It is a good practice to 
	 * "precompute" the next available tuple in this function and return it
	 * by a call of {@link #getNext()}.
	 * @return <code>true</code> if there are more tuples, <code>false<code> otherwise.
	 */
	public boolean hasNext()
	{
		if (preds_valid)
			next_exists = this.getNextTuple();
		else
			return false;
		
		return next_exists;
	}
	
	public boolean getNextTuple()
	{
		boolean found = false,
				found_right = false,
				found_left = true;
		
		while (found == false)
		{
			if (rightIt.hasNext())
			{
				nRightTup= rightIt.getNext();
				found_right = true;
			}
			else
			{
				if (leftIt.hasNext())
				{
					nLeftTup= leftIt.getNext();
					rightIt.restart();
					
					
					rightIt.hasNext();					
					nRightTup = rightIt.getNext();
					found_left = true;
					found_right = true;
				}
				else				
				{
					return false;
				}				
			}
			
			
			if (found_right && found_left)
			{
				Tuple joined = Tuple.join(nRightTup, nLeftTup, this.schema);

				if (testPredicts(joined))
				{
					found = true;
					this.nextTuple = joined;		
					return true;
				}				
			}
			else
			{
				this.nextTuple = null;
				return false;				
			}					
						
		}
		return found;	
	}
	
	public boolean testPredicts(Tuple t)
	{
		int arrayLength = predicts.length;		
		
		for (int i = 0; i<=arrayLength-1; i++)
		{
			if (!(predicts[i].evaluate(t)))
				return false;
		}
		return true;
		
	}

	/**
	 * Gets the next tuple in the iteration.
	 * @return The next available {@link relop.Tuple} object of the relation.
	 * @throws IllegalStateException if no more tuples
	 */
	public Tuple getNext() throws IllegalStateException
	{	
		if (! (preds_valid))
			return null;
		else			
			return this.nextTuple;		
	}
}
