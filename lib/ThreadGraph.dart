
class ThreadNode{
  ThreadNode parent;
  ThreadNode child = null;
  String key;
  String content;

  ThreadNode(ThreadNode parent, String key, String content){
    this.parent = parent;
    this.content = content;
    this.key = key;
  }

  _setChild(ThreadNode child){
    this.child = child;
  }

}



class Thread {
  List<ThreadNode> nodes;
  Map<ThreadNode, ThreadNode>  edges; //list of maps id nodes to nodes

  DFSGraph(){
    this.nodes = [];
    this.edges = new Map();
  }

   _addNode(ThreadNode node){ // for whenever the graph is already populated and the parent will be there

    
    
    this.nodes.add(node);
//    this.edges.putIfAbsent(node, node.parent)

  }

  _sortNodes(){
     List<ThreadNode> sortedNode = [];

     for(ThreadNode n in this.nodes){
       if(n.parent == null){

       }
     }
  }



}

void main(){
  Thread thread = new Thread();
  ThreadNode post = new ThreadNode(null, "post",  "POST");
  ThreadNode replyA = new ThreadNode(post ,"replyA", "reply a");
  ThreadNode replyB = new ThreadNode(post, "replyB", "reply b");
  ThreadNode replyC = new ThreadNode(replyA, "replyC", "reply b");
  ThreadNode replyD = new ThreadNode(replyA, "replyD", "reply d");
  ThreadNode replyE = new ThreadNode(replyC, "replyE", "reply e");


  thread._addNode(post);
  thread._addNode(replyA);
  thread._addNode(replyB);
  thread._addNode(replyC);
  thread._addNode(replyD);
  thread._addNode(replyE);






}