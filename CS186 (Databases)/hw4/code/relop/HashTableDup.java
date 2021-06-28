package relop;

import global.SearchKey;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.Hashtable;

/**
 * <p>CS186 - Spring 2007 - Homework 4: Join Operators</p>
 * <p>An extension to Java's hash table that allows duplicate keys.
 * Use this class for your in-memory hashtable, in the second phase of
 * your HashJoin implementation. You <b>do not need</b> to modify it.
 * See <a href="http://mindprod.com/jgloss/hashtable.html">http://mindprod.com/jgloss/hashtable.html</a></p>
 * @version 1.0
 */
@SuppressWarnings("unchecked")
class HashTableDup extends Hashtable
{
	private static final long serialVersionUID = 2636082502377587594L;

	/**
	 * Maps the specified key to the specified value in this hashtable.
	 * @param key The {@link global.SearchKey} object to be mapped to the
	 * specified {@link relop.Tuple} object.
	 * @param value The {@link relop.Tuple} object to be inserted in the
	 * hashtable.
	 */
	public void add(SearchKey key, Tuple value)
	{
		// To conserve RAM, duplicate values are either stored as single objects,
		// pairs in an array, or multiples in an ArrayList
		Object existing = get(key);
		if (existing == null)
		{
			// store the single value
			put(key, value);
		}
		else if (existing instanceof Tuple)
		{
			// was a single object; make into a pair
			put(key, new Tuple[] { (Tuple) existing, value });
		}
		else if (existing instanceof Tuple[])
		{
			// was a pair; make into an ArrayList of 3
			ArrayList<Tuple> a = new ArrayList<Tuple>();
			a.addAll(Arrays.asList((Tuple[]) existing));
			a.add(value);
			put(key, a);
		}
		else
		{
			// just add to tail end of existing ArrayList
			((ArrayList<Tuple>) existing).add(value);
		} // else

	} // public void add(SearchKey key, Tuple value)

	/**
	 * Returns the values to which the specified key is mapped in this hashtable.
	 * @param key The {@link global.SearchKey} object to guide the search for tuples.
	 * @param value An array of {@link relop.Tuple} objects associated with <code>key</code>.
	 */
	public Tuple[] getAll(SearchKey key)
	{
		// look up the key
		Object match = get(key);
		if (match == null)
		{
			// not found
			return null;
		}
		else if (match instanceof Tuple)
		{
			// return the single match
			return new Tuple[] { (Tuple) match };
		}
		else if (match instanceof Tuple[])
		{
			// return the matches
			return (Tuple[]) match;
		}
		else
		{
			// convert ArrayList to Tuple[]
			ArrayList<Tuple> a = (ArrayList<Tuple>) match;
			return a.toArray(new Tuple[a.size()]);
		} 
	}
} 
