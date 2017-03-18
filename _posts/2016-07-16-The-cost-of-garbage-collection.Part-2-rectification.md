---
layout: post
title: The cost of garbage collection. Part 2 - rectification.
description: "An update to a try to measure the time cost of garbage collection in .NET."
modified: 2016-07-16
tags: [.NET, performance, GC, Garage collection, benchmark, GC.Collect, NBench]
series: "The cost of garbage collection"
image:
  feature: data/2016-07-16-The-cost-of-garbage-collection.Part-2-rectification/logo.jpg
---

This is a rectification for the [previous post about the cost of garbage collection](/The-cost-of-garbage-collection/). If You didn't read it give it a try and check if You can spot the bug/mistake.

Like [Konrad](http://blog.kokosa.net/) pointed out in [his comment](http://disq.us/p/1a0iccx) not all objects were in generation 0 as I assumed. This is partly connected to the fact that .NET, seeing rapid need for memory in `Setup`, will try to collect some of them, calling garbage collection, but I make the matters worse by calling `GC.Collect` in the end. So making sure that objects created during `Setup` will be in generation 2 (in my defence it was left over after a bit different take on this problem).

This is the proper code (it also was committed to the [github repo](https://github.com/maklipsa/CSharpPerfExperiments)):
<!--MORE-->

```csharp
using System;
using System.Collections.Generic;
using System.Diagnostics;
using System.Runtime.CompilerServices;
using NBench;

namespace Tests
{
    public class GCCollection
    {
        private readonly string[] _messages =
        {
            "Gen 0 ticks:       ",
            "Gen 0+1 ticks:     ",
            "Gen 0+1+2 ticks:   "
        };

        private readonly int _objectNumber = 20*1000;

        [PerfSetup]
        public void Setup(BenchmarkContext context)
        {
            Console.WriteLine("Objects generated.");
            GenerateObjects(_objectNumber*2);
            GC.Collect(2, GCCollectionMode.Forced, true, true);
        }

        [PerfBenchmark(Description = "Gen 2 collection with nothing", NumberOfIterations = 1, RunMode = RunMode.Iterations, TestMode = TestMode.Test)]
        [GcTotalAssertion(GcMetric.TotalCollections, GcGeneration.Gen0, MustBe.ExactlyEqualTo, 3d)]
        [GcTotalAssertion(GcMetric.TotalCollections, GcGeneration.Gen1, MustBe.ExactlyEqualTo, 2d)]
        [GcTotalAssertion(GcMetric.TotalCollections, GcGeneration.Gen2, MustBe.ExactlyEqualTo, 1d)]
        public void Gen2CollectionWithNothing()
        {
            GC.Collect(2, GCCollectionMode.Forced, true,true);

            var sw = Stopwatch.StartNew();

            RunGCAndCheck(0, sw);/* Run collect for gen 0 - collect everything.*/

            RunGCAndCheck(1, sw);/* Nothing should be here.*/

            RunGCAndCheck(2, sw);/* Nothing should be here.*/
        }

        [PerfBenchmark(Description = "Gen 0 collection", NumberOfIterations = 1, RunMode = RunMode.Iterations,TestMode = TestMode.Test)]
        [GcTotalAssertion(GcMetric.TotalCollections, GcGeneration.Gen0, MustBe.ExactlyEqualTo, 1d)]
        [GcTotalAssertion(GcMetric.TotalCollections, GcGeneration.Gen1, MustBe.ExactlyEqualTo, 0.0d)]
        [GcTotalAssertion(GcMetric.TotalCollections, GcGeneration.Gen2, MustBe.ExactlyEqualTo, 0.0d)]
        public void Gen0Collection()
        {
            var list = GenerateObjects(_objectNumber);
            list = null;

            var sw = Stopwatch.StartNew();

            RunGCAndCheck(0, sw);/* Run collect for gen 0 - collect everything.*/
        }


        [PerfBenchmark(Description = "Gen 1 collection", NumberOfIterations = 1, RunMode = RunMode.Iterations,TestMode = TestMode.Test)]
        [GcTotalAssertion(GcMetric.TotalCollections, GcGeneration.Gen0, MustBe.ExactlyEqualTo, 2.0d)]
        [GcTotalAssertion(GcMetric.TotalCollections, GcGeneration.Gen1, MustBe.ExactlyEqualTo, 1.0d)]
        [GcTotalAssertion(GcMetric.TotalCollections, GcGeneration.Gen2, MustBe.ExactlyEqualTo, 0.0d)]
        public void Gen1Collection()
        {
            var list = GenerateObjects(_objectNumber);
            var sw = Stopwatch.StartNew();
            RunGCAndCheck(0, sw);/* Can't collect anything. Move it to gen 1.*/

            list = null;
            RunGCAndCheck(1, sw);/* Run collect for gen 0 - it is empty. Run gen 1 collection - collect everything.*/
        }

        [PerfBenchmark(Description = "Gen 2 collection", NumberOfIterations = 1, RunMode = RunMode.Iterations,TestMode = TestMode.Test)]
        [GcTotalAssertion(GcMetric.TotalCollections, GcGeneration.Gen0, MustBe.ExactlyEqualTo, 3.0d)]
        [GcTotalAssertion(GcMetric.TotalCollections, GcGeneration.Gen1, MustBe.ExactlyEqualTo, 2.0d)]
        [GcTotalAssertion(GcMetric.TotalCollections, GcGeneration.Gen2, MustBe.ExactlyEqualTo, 1.0d)]
        public void Gen2Collection()
        {
            var list = GenerateObjects(_objectNumber);
            var sw = Stopwatch.StartNew();

            RunGCAndCheck(0, sw);/* Can't collect anything. Move it to gen 1.*/

            RunGCAndCheck(1, sw);/* Run collect for gen 0 - it is empty. Run gen 1 collection - collect the list elements.*/

            list = null;
            RunGCAndCheck(2, sw);/* Run collect for generation 0 - it is empty. Run collect for generation 1 - it is empty. Run collect for generation 2 - collect everything.*/
        }

        [MethodImpl(MethodImplOptions.AggressiveInlining)]
        private void RunGCAndCheck(int generationNumber, Stopwatch sw)
        {
            sw.Restart();
            GC.Collect(generationNumber, GCCollectionMode.Forced, true,true);
            Console.WriteLine(_messages[generationNumber] + sw.ElapsedTicks);
        }

        private List<MyGCTestClass> GenerateObjects(long count)
        {
            var ret = new List<MyGCTestClass>();
            for (var i = 0; i < count; i++)
            {
                ret.Add(new MyGCTestClass(Guid.NewGuid().ToString()));
            }
            return ret;
        }

        private class MyGCTestClass
        {
            private readonly string Text;

            public MyGCTestClass(string text)
            {
                Text = text;
            }

            public MyGCTestClass(MyGCTestClass source)
            {
                Text = source.Text;
            }
        }
    }
}
```

## What has changed:
- This code generates 'only' 20 thousand objects because it is the maximal number that does not trigger garbage collection at my machine. 
- `Setup` generates 40 thousand objects to make sure .NET will preallocate enough memory for the process so when tests are run it won't need to ask the OS for additional memory. It also triggers `GC.Collect(2)` after it to make sure that all objects will be collected and the test will have a clean run.
- `GenerateObjects` is called in every test to make sure I measure any `GC.Collect` that may affect in which generation objects are in.  

And the results (I spared the NBench info, so just the numbers).

### Gen0Collection

Gen 0 ticks:       6167

### Gen1Collection

Gen 0 ticks:       6153
Gen 0+1 ticks:     5059
 
### Gen2Collection

Gen 0 ticks:       4963
Gen 0+1 ticks:     4772
Gen 0+1+2 ticks:   2955
 
### Gen2CollectionWithNothing

Gen 0 ticks:       171
Gen 0+1 ticks:     140
Gen 0+1+2 ticks:   1365

## Final thoughts: 
1. `GC.Collect(1)` takes a bit less time (keep in mind we are talking in ticks, not even miliseconds!) than `GC.Collect(0)`. For me it was not intuitive, and strange since calling `GC.Collect(1)` also calls `GC.Collect(0)`. 
2. And finally to answer [Michał's question](http://disq.us/p/18p9xvb). I think generation 0 and generation 1 algorithms are a bit different, and definitely generation 2 uses different, more complicated algorithm.