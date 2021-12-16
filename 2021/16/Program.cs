var demoInput1 = "D2FE28";
var demoInput2 = "38006F45291200";
var demoInput3 = "EE00D40C823060";
var demoInput4 = "8A004A801A8002F478";
var demoInput5 = "A0016C880162017C3686B18A3D4780";

var demoInput6 = "C200B40A82";
var demoInput7 = "04005AC33890";
var demoInput8 = "9C0141080250320F1802104A08";

var actualInput = "C20D42002ED333E7774EAAC3C2009670015692C61B65892239803536C53E2D307A600ACF324928380133D18361005B336D3600B4BF96E4A59FED94C029981C96409C4A964F995D2015DE6BD1C6E7256B004C0010A86B06A1F0002151AE0CC79866600ACC5CABC0151006238C46858200E4178F90F663FBA4FDEC0610096F8019B8803F19A1641C100722E4368C3351D0E9802D60084DC752739B8EA4ED377DE454C0119BBAFE80213F68CDC66A349B0B0053B23DDD61FF22CB874AD1C4C0139CA29580230A216C9FF54AD25A193002A2FA002AB3A63377C124205008A05CB4B66B24F33E06E014CF9CCDC3A2F22B72548E842721A573005E6E5F76D0042676BB33B5F8C46008F8023301B3F59E1464FB88DCBE6680F34C8C0115CDAA48F5EE45E278380019F9EC6395F6BE404016849E39DE2EF002013C873C8A401544EB2E002FF3D51B9CAF03C0010793E0344D00104E7611C284F5B2A10626776F785E6BD672200D3A801A798964E6671A3E9AF42A38400EF4C88CC32C24933B1006E7AC2F3E8728C8E008C759B45400B4A0B4A6CD23C4AF09646786B70028C00C002E6D00AEC1003440080024658086A401EE98070B50029400C0014FD00489000F7D400E000A60001E870038800AB9AB871005B12B37DB004266FC28988E52080462973DD0050401A8351DA0B00021D1B220C1E0013A0C0198410BE1C180370C21CC552004222FC1983A0018FCE2ACBDF109F76393751D965E3004E763DB4E169E436C0151007A10C20884000874698630708050C00043E24C188CC0008744A8311E4401D8B109A3290060BE00ACEA449214CD7B084B04F1A48025F8BD800AB4D64426B22CA00FC9BE4EA2C9EA6DC40181E802B39E009CB5B87539DD864A537DA7858C011B005E633E9F6EA133FA78EE53B7DE80";

static string hexToBinaryString(string input) =>
    string.Join("", input.Select(c => Convert.ToString(Convert.ToInt32(c.ToString(), 16), 2).PadLeft(4, '0')));

static long binaryStringToInt(string input) => Convert.ToInt64(input, 2);

static (long, int) parseLiteral(string input, int pointer)
{
    var number = "";
    var last = false;
    while (!last)
    {
        if (input[pointer] == '0') last = true;
        number += input[(pointer + 1)..(pointer + 5)];
        pointer += 5;
    }
    return (binaryStringToInt(number), pointer);
}

static resultNumbers parse(string input, int pointer)
{   
    var version = binaryStringToInt(input[pointer..(pointer + 3)]);
    pointer += 3;
    var packetType = binaryStringToInt(input[pointer..(pointer + 3)]);
    pointer += 3;
    long? number = null;
    if (packetType == 4)
    {
        //literal
        var (num, ptr) = parseLiteral(input, pointer);
        number = num;
        pointer = ptr;
    }
    else
    {
        //operation
        var lengthType = input[pointer];
        var operands = new List<long>();
        if (lengthType == '0')
        {
            var length = binaryStringToInt(input[(pointer + 1)..(pointer + 16)]);
            pointer += 16;
            var pointerToGoFrom = pointer;
            while (pointerToGoFrom + length > pointer)
            {
                var (ver, ptr, num) = parse(input, pointer);
                if (num != null) operands.Add(num.Value);
                version += ver;
                pointer = ptr;
            }
        }
        else
        {
            var length = binaryStringToInt(input[(pointer + 1)..(pointer + 12)]);
            pointer += 12;
            for (var i = 0; i < length; i++)
            {
                var (ver, ptr, num) = parse(input, pointer);
                if (num != null) operands.Add(num.Value);
                version += ver;
                pointer = ptr;
            }
        }
        switch (packetType)
        {
            case 0:
                number = operands.Sum();
                break;
            case 1:
                number = operands.Aggregate((long)1, (x, y) => y *= x);
                break;
            case 2:
                number = operands.Min();
                break;
            case 3:
                number = operands.Max();
                break;
            case 5:
                number = operands[0] > operands[1] ? 1 : 0;
                break;
            case 6:
                number = operands[0] < operands[1] ? 1 : 0;
                break;
            case 7:
                number = operands[0] == operands[1] ? 1 : 0;
                break;
        }
    }
    return new resultNumbers((int)version, pointer, number);
}

var pointer = 0;
var totalVersion = 0;
long? totalNumber = 0;
var inputBinary = hexToBinaryString(actualInput);

while (pointer != inputBinary.Length)
{
    (totalVersion, pointer, totalNumber) = parse(inputBinary, pointer);
    if (!inputBinary[pointer..].Contains('1')) break;
}

Console.WriteLine($"Part 1: {totalVersion}");
Console.WriteLine($"Part 2: {totalNumber}");

record struct resultNumbers(int Version, int Pointer, long? Number) { }