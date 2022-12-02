int score01 = 0;
int score02 = 0;
using (var str = File.OpenText("input.txt")){
    while(!str.EndOfStream)
    {
        var l = str.ReadLine();
        var turn = l.Split(' ');
        if ((turn[0] == "A" && turn[1] == "Y") || (turn[0] == "B" && turn[1] == "Z") || (turn[0] == "C" && turn[1] == "X"))
            score01+=6;
        if ((turn[0] == "A" && turn[1] == "X") || (turn[0] == "B" && turn[1] == "Y") || (turn[0] == "C" && turn[1] == "Z"))
            score01+=3;
        switch (turn[1]){
            case "X":{
                score01+=1;
                switch (turn[0]) {
                    case "A" : score02+=3; break;
                    case "B" : score02+=1; break;
                    case "C" : score02+=2; break;
                } 
                break;
            }
            case "Y":{
                score01+=2; 
                score02+=3; 
                switch (turn[0]) {
                    case "A" : score02+=1; break;
                    case "B" : score02+=2; break;
                    case "C" : score02+=3; break;
                } 
                break;
            }
            case "Z":{
                score01+=3; 
                score02+=6;
                switch (turn[0]) {
                    case "A" : score02+=2; break;
                    case "B" : score02+=3; break;
                    case "C" : score02+=1; break;
                } 
                break;
            }
        }
    }
}
// part 1
Console.WriteLine(score01);
Console.WriteLine(score02);
