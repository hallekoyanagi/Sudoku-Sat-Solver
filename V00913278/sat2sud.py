import sys

def sat2sud(sat):
    sat = sat.replace("\n", " ").replace("\r", "")
    sat = sat.split(" ")[1:]
    res = ""
    count = 0
    for i in range(729):
        if int(sat[i]) > 0:
            num = "9" if int(sat[i]) % 9 == 0 else str(int(sat[i]) % 9)
            res += num
            count += 1
            if count % 9 == 0:
                res += '\n'
                continue
            if count % 3 == 0:
                res += " "   
    
    return res


if __name__ == "__main__":
    # with open("assign.txt", "r") as file:
    #     print(sat2sud(file.read()))
    print(sat2sud(sys.stdin.read()))