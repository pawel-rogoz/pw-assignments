import json
from matplotlib import pyplot as plt


def reading_mean():
    with open("results.json", 'r') as fp:
        reader = json.load(fp)
        for i in range(4):
            print(reader["benchmarks"][i]["stats"]["mean"])



def plot_all(time_results):
    words_number = [1000, 2000, 3000, 4000, 5000, 6000, 7000, 8000, 9000, 10000]
    leg = ["bubble", "selection", "merge", "quick"]
    plt.plot(words_number, time_results)
    plt.legend(leg)
    plt.xlabel("NUMBER OF WORDS")
    plt.ylabel("TIME")
    plt.savefig("plot_all.png")
    plt.show()

def plot_merge_quick(time_mergeandquick):
    words_number = [1000, 2000, 3000, 4000,
                    5000, 6000, 7000, 8000, 9000, 10000]
    plt.plot(words_number, time_mergeandquick)
    leg = ["merge", "quick"]
    plt.legend(leg)
    plt.xlabel("NUMBER OF WORDS")
    plt.ylabel("TIME")
    plt.savefig("merge_quick.png")
    plt.show()


if __name__=="__main__":
    time_results = [[96.46178754546368, 39.004189310358484, 1.5446976695824919, 1.2945421534778543], [405.83159779998823, 138.21706560001985, 3.6328031608859033, 2.6263942412012953], [646.7443738000384, 223.84175080001114, 5.2303849900022215, 3.8826607283334043], [995.4589130000386, 350.88043440005094, 7.0731123698634875, 5.605620385024504], [1571.2421541999902, 831.0767641999973, 9.064985141595466, 7.085971668976558], [
    2319.107299999905, 858.4744790000059, 11.177630365575894, 8.566833804877199], [3302.697423000018, 1085.5094912000368, 13.880300178090867, 10.137493846153452], [4427.411996799999, 1454.3798459999948, 15.765718523076742, 11.65301339130618], [5540.10170499987, 1858.6402690000796, 17.980601271165913, 13.58306353165373], [7084.734600400134, 2544.9447945999054, 19.946030557688434, 14.67293424282486]]
    plot_all(time_results)
