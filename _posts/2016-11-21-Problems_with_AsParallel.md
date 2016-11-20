---
layout: post
title: Problems with AsParallel
description: "AsParallel is almost a silver bullet. But like all bullets, You can shoot yourself in the foot. And where it hurts the most. Here are some tips how to avoid that."
modified: 2016-11-21
tags: [.NET, AsParallel, parallelism, Performance]
image:
  feature: data/2016-11-21-Problems_with_AsParallel/logo.jpg
---

This post is covering a subset of what I am talking in my talk [How I stopped worrying and learned to love parallel processing](https://www.youtube.com/watch?v=Dup24FdDYj4) (currently only in polish).


This will cover on how, in terms of performance, [AsParallel](https://msdn.microsoft.com/en-us/library/system.linq.parallelenumerable.asparallel(v=vs.110).aspx) can kick you in a place where it hurts a lot, simultaneously being a blessing in terms of... performance. How is that? Let's look at some 

## History

AsParallel was introduced as an extension to [LINQ](https://msdn.microsoft.com/en-us/library/bb308959.aspx) with [TPL](https://msdn.microsoft.com/en-us/library/dd460717(v=vs.110).aspx) in .NET 4.0. In theory, it's God's sent. The promise was that it will:

 - parallelize the LINQ query.
 - take care of all thread management and synchronization. 
 - adjust the number of Tasks automatically.
 - not require any additional code changes except for ``.AsParallel()``

And in the vast majority of cases, this promise was kept! For example look at this code: 
<!--MORE-->

## When it is awesome

```csharp
void Main()
{
    //create a list
    const int _numberCount = 1*1000*1000;
    var list = new List<int>(_numberCount);
    for (var i = 0; i < _numberCount; i++)
    {
        list.Add(i);
    }    
    //calculate in one thread
    MeasureTime(() => list
                        .Where(IsPrime)
                        .Count()
                );

    //use AsParallel
    MeasureTime(() => list
                        .AsParallel()
                        .Where(IsPrime)
                        .Count()
                );
}
//very bad way to calculate a prime. Not for production usage ;) 
internal static bool IsPrime(int number)
{
    if (number == 1) return false;
    if (number == 2) return true;

    var boundary = (int) Math.Floor(Math.Sqrt(number));

    for (var i = 2; i <= boundary; ++i)
    {
        if (number%i == 0) return false;
    }

    return true;
}

private static void MeasureTime(Func<int> a)
{
    var sw = Stopwatch.StartNew();
    a();
    sw.Stop();

    Console.WriteLine("Took: " + sw.ElapsedMilliseconds);
}
```

This is a trivial example (a more real live one was published recently by Ayende [here](https://ayende.com/blog/176035/making-code-faster-the-obvious-costs), [here](https://ayende.com/blog/176036/making-code-faster-starting-from-scratch), [here](https://ayende.com/blog/176037/making-code-faster-going-down-the-i-o-chute) and [here](https://ayende.com/blog/176037/making-code-faster-going-down-the-i-o-chute)), but stay with me. 
In this case, the difference between single threaded and parallel execution is as follows:

```console
Single threaded: 570
AsParallel: 138
```

This is more than **4-time speed up** with only 1 line and no additional code changes. Looks like all the promises were kept.  

But sometines things don't go that good.

## AsParallel on a to small set

Let's change that code, and set the list size to 100. Then the results will look like that:

```console
Single threaded: 4
AsParallel: 15
```

And yes. Those numbers are tiny. But if you have them in every web request, or a small frequently called function it cumulates. 
If talking about small functions they have a habit of being used in other functions, thus creating bigger blocks. Those blocks tend to be ... parallelized. So let's see what happens then.

## Nested AsParallel   

It is more or less the same code as above, but now we have:

 - ``CalcInSingleAsParallel`` that calculates the prime using ``AsParallel`` (same as above)'
 - we split the list into chunks and then on them in parallel call ``CalcInSingleAsParallel``. This is done in ``CalcInTwoNestedAsParallel``.

> One thing to note about ``CalcInTwoNestedAsParallel`` is that it splits the list into chunks when being invoked, but returns an ``IEnumerable``. This trick defers the calculation of the prime until ``Count`` is being called. This way ``MeasureTime`` only measures the prime calculating part.
  
```csharp
void Main()
{
    //create the list
    const int _numberCount = 1*1000*1000;
    var list = new List<int>(_numberCount);
    for (var i = 0; i < _numberCount; i++)
    {
        list.Add(i);
    }
    // split the list into 10 fragments and return an IEnumerable<IEnumerable<int>>
    var tenFragments = CalcInTwoNestedAsParallel(list, 10);
    MeasureTime(
                () => tenFragments.Sum(a => a.Count())
    );
    
    // split the list into 100 fragments and return an IEnumerable<IEnumerable<int>>
    var hundretFragments = CalcInTwoNestedAsParallel(list, 100);
    //calculate the prime number
    MeasureTime(
                () => hundretFragments.Sum(a => a.Count())
    );
    
    // split the list into 1000 fragments and return an IEnumerable<IEnumerable<int>>
    var thousandFragments = CalcInTwoNestedAsParallel(list, 1000);
    //calculate the prime number
    MeasureTime(
                () => thousandFragments.Sum(a => a.Count())
    );
}
private static IEnumerable<IEnumerable<int>> CalcInTwoNestedAsParallel(List<int> numbers, int chunkNumber)
{
    var numbersChunks = ToChunks(numbers, chunkNumber);
    return numbersChunks
        .AsParallel()
        .Select(CalcInSingleAsParallel)
        ;
}
private static IEnumerable<int> CalcInSingleAsParallel(List<int> numbers)
{
    return numbers
        .AsParallel()
        .Where(IsPrime)
        ;
}

private static List<List<int>> ToChunks(List<int> source, int nSize = 30)
{
    var ret = new List<List<int>>();
    for (var i = 0; i < source.Count; i += nSize)
    {
        var tmp = source.GetRange(i, Math.Min(nSize, source.Count - i));
        ret.Add(tmp);
    }
    return ret;
}
internal static bool IsPrime(int number)
{
    if (number == 1) return false;
    if (number == 2) return true;

    var boundary = (int) Math.Floor(Math.Sqrt(number));

    for (var i = 2; i <= boundary; ++i)
    {
        if (number%i == 0) return false;
    }

    return true;
}
private static void MeasureTime(Func<int> a)
{
    var sw = Stopwatch.StartNew();
    a();
    sw.Stop();
    Console.WriteLine("Took: " + sw.ElapsedMilliseconds);
}
```

The results look like this:

```console
For 10 chunks containing 100 000 elements it took: 1737
For 100 chunks containing 10 000 elements it took: 361
For 1000 chunks containing 1 000 elements it took: 228
```

We have a **~7.6 times difference** between the best and the words run, and **~12.5 times difference** when compared to a single ``AsParallel``! 
It gets even worse when we nest it into another ``AsParallel`` (while maintaining the same total amount of calculations being done):

```console
For 10*10 chunks containing 10 000 elements it took: 3061
For 100*100 chunks containing 100 elements it took: 571
For 1000*1000 chunks containing 1 elements it took: 284
```

> Take a look again at the last line:
> For 1000*1000 chunks containing 1 elements it took: 284
> It was the fastest in this run although having very tiny (one element) lists.

The difference between the best and the worst run is this case is **11 times**. 
When compared to the best run (a single ``AsParallel``) it is more than **22 times slower!** 
Why is that?

## The profiler
This is the dotTrace result for all of the above:

No nesting, single ``AsParallel``:
![single AsParallel](/data/2016-11-21-Problems_with_AsParallel/NoNesting.png)

One nesting (so two ``AsParallel``), 10 segments:
![two nested AsParallel](/data/2016-11-21-Problems_with_AsParallel/OneNesting_10.png)

Two nestings (so three ``AsParallel``), 10*10 chunks:
![three nested AsParallel](/data/2016-11-21-Problems_with_AsParallel/TwoNesting_10.png)

With this the answer becomes obvious. The cost is hidden in switching and managing threads. TPL's task scheduler  is creating threads and tries to distribute work among them using tasks. The same time the operating system is switching between them trying to give each a slice of processors time. All this managing is responsible for 22 times increase in time needed. 

> This shows that micro-managing is not a good thing. In programming or in the real world ;)

# Conclusion

``AsParallel`` gives mind blowing performance gains with little to none effort. But it can't be treated as a silver bullet. 
When you decide to use it:

- profile the whole process. 
- ``AsParallel`` is dependent on the data size. So have performance tests with wide range of size of the processed data
- when used in a web application, test it under load. IIS likes to have control over threads and you are messing with it.

**Use with caution**