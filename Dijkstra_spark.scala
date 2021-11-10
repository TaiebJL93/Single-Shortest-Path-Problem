//importing the libraries
import org.apache.spark._
import org.apache.spark.graphx._
import org.apache.spark.rdd.RDD
import scala.util.Random.nextInt

//loading the inputfile  
val graph = GraphLoader.edgeListFile(sc, "hdfs:/user/hadoop/Working_Dir/RawData_Input_Dir/email-Eu-core-temporal.txt")


//initializing the source Node
val sourceId: VertexId = 0

//adding weights to edges
val f = graph.mapVertices( (id, _) =>
  if (id == sourceId) Array(0.0, id)
  else Array(Double.PositiveInfinity, id)
).mapEdges( e => e.attr.toInt )
new scala.util.Random
// vizializing edges and vertices
g.vertices.take(10)
g.edges.take(10)

//calculating the shortest path using pergel
val sssp = g.pregel(Array(Double.PositiveInfinity, -1))(
  (id, dist, newDist) => {
    if (dist(0) < newDist(0)) dist
    else newDist
  },
triplet => {
  if (triplet.srcAttr(0) + triplet.attr < triplet.dstAttr(0)) {
    Iterator((triplet.dstId, Array(triplet.srcAttr(0) + triplet.attr, triplet.srcId)))
  }
  else {
    Iterator.empty
  }
},
(a, b) => {
  if (a(0) < b(0)) a
  else b
  }
)

//preparing output to print
val ans: RDD[String] = sssp.vertices.map(vertex =>
    "Vertex " + vertex._1 + ": distance is " + vertex._2(0) + ", previous node is Vertex " + vertex._2(1).toInt)

//Printing the 10 first reults 
ans.take(10).mkString("\n")

//saving the results
ans.saveAsTextFile("hdfs://user/user107/outputspark)
