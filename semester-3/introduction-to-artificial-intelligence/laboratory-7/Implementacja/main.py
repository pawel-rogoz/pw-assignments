from dataset import Dataset
from splitter import Splitter
from naive_bayes import NaiveBayes

def main():
    dataset = Dataset('iris.csv')
    summarizer = Splitter(dataset)
    naive_bayes = NaiveBayes(dataset, summarizer, 3)
    print(naive_bayes)

if __name__ == "__main__":
    main()