---
layout: post
title: Dividing a bit in two for performance
description: "Bit operations are fast, but they can still be made faster"
modified: 2016-12-20
tags: [.NET, cookit, performance, similarity, bit operations]
image:
  feature: data/2016-12-20-Dividing-a-bit-in-two-for-performance/logo.jpg
---

This post is description of a very interesting optimization proposed by Nicholas Frechette in the comments under the [previous post](/Making-bits-faster/).

He proposed to use one of the oldest trick in performance book - [divide and conquer](https://en.wikipedia.org/wiki/Divide_and_conquer_algorithms). 

<!--MORE-->


This post was inspired by a [discussion on Reddit](https://www.reddit.com/r/programming/comments/5i2x5r/using_bit_masks_for_highperformance_calculations/) that followed my [previous post](http://indexoutofrange.com/Using-bit-operations-for-performance-optimizations/)

In this post, I will cover a [suggestion](https://www.reddit.com/r/programming/comments/5i2x5r/using_bit_masks_for_highperformance_calculations/db5ujwc/) by [BelowAverageITGuy](https://www.reddit.com/user/BelowAverageITGuy) that cut down the total execution time by almost one hour.
<!--MORE-->

## Saga

Before I go further here are some link to the previous posts on the problem of calculating similarities and then optimizing it grew to few post. Here are all of them:

- [How I calculate similarities in cookit?](/How_I_calculate_similarities_in_cookit)
- [How to calculate 17 billion similarities](/How-to-calculate-17-billion-similarities)
- [Independent code in performance optimizations](/Independent-code-in-performance-optimizations)
- [Using bit masks for high performance calculatons](/Using-bit-operations-for-performance-optimizations)
- [Making bits faster](/Making-bits-faster/)

## Recap 

The last implementation of `GetNonZeroIndexes` looked like this:

```csharp
        public IList<int> GetNonZeroIndexes()
        {
            List<int> ret= new List<int>();
            for (var i = 0; i < _array.Length; i++)
            {
                var a = _array[i];
                if (a != 0UL)
                {
                    if ((a & 1UL) != 0UL) ret.Add(i * 64 + 0);
                    if ((a & 2UL) != 0UL) ret.Add(i * 64 + 1);
                    if ((a & 4UL) != 0UL) ret.Add(i * 64 + 2);
                    if ((a & 8UL) != 0UL) ret.Add(i * 64 + 3);
                     .
                    .
                    .
                    .
                    .
                    if ((a & 1152921504606846976UL) != 0UL) ret.Add(i * 64 + 60);
                    if ((a & 2305843009213693952UL) != 0UL) ret.Add(i * 64 + 61);
                    if ((a & 4611686018427387904UL) != 0UL) ret.Add(i * 64 + 62);
                    if ((a & 9223372036854775808UL) != 0UL) ret.Add(i * 64 + 63);
                }
            }
            return ret;
        }
```

How can this get better?

## Divide and conquer

The above approach is a brute force approach. Why? I am checking for every bit if it is set. This is waistfull since most of them are not set (remember those are [sparse arrays](/Using-bit-operations-for-performance-optimizations)). The better approach would be to test multiple bits at once. How? Bit masks - as always :)

I could replace `GetNonZeroIndexes` with this code:

```csharp
public IList<int> GetNonZeroIndexes()
{
    var ret = new List<int>();
    for (var i = 0; i < _array.Length; i++)
    {
        var a = _array[i];
        if (a != 0UL) //is any bit set?
        {
            if ((a & BitVectorMaskConsts._0_32) > 0) //is any of the 32 least significant bits set?
            {
                if ((a & BitVectorMaskConsts._0_16) > 0) //is any of the 16 least significant bits set?
                {
                    if ((a & BitVectorMaskConsts._0_8) > 0) //is any of the 8 least significant bits set?
                    {
                        if ((a & BitVectorMaskConsts._0_4) > 0) //is any of the 4 least significant bits set?
                        {
                            if ((a & 1UL) != 0UL) ret.Add(i*64 + 0);
                            if ((a & 2UL) != 0UL) ret.Add(i*64 + 1);
                            if ((a & 4UL) != 0UL) ret.Add(i*64 + 2);
                            if ((a & 8UL) != 0UL) ret.Add(i*64 + 3);
                        }
                        if ((a & BitVectorMaskConsts._4_8) > 0){
						.
						.
						.
						.

                    }
                }
            }
        }
    }
    return ret;
}
```    

Why is this code faster? If my array contains only one set bit I will do **only from 6 to 9 comparisons** compared to 65 previosly. Don't believe me? I can prove it mathematicly!

### Complexity

What divide and conquer is doing is simulating a [binary tree](https://en.wikipedia.org/wiki/Binary_tree) consisting of:

```console
64/4 = 16 elements

where:
- 64 - number of elements
- 4 - at this size I am no longer dividing
```

Since my tree is fully balanced (equal number of nodes on the left and right) its max depth is equal to `log n`. With `n` equal to 16 this gives me depth equal to 4. 

But I've written that I have to do at least six checks. This is because I have to do two extra ones:

- check if any bit is set (first check if the number is a zero)
- from one to four checks to iterate over specific bits. This step can be reduced by one. Do You know how?

## Performance results

How did it affect performance? The [last best sample run](/Making-bits-faster/) took 297 seconds. This takes 248 seconds. This translates to:

```console    
(283 / 2199) * 182184 ~ 6,5 hours (starting from 34 hours, and 6,8 in the best run)
```

This way I've managed to be faster by **another hour** in total run.

### Smaller is better

But how much does dividing impact performance?

Here are the results:

|---
| Size of the chunk | Execution time |
|:-|--------------------:|
|32| 277 seconds|
|16| 296 seconds|
|8| 293 seconds| 
|4| 283 seconds|
|2| 297 seconds|

<style>
table{
    width:300px !important;
}
</style>
