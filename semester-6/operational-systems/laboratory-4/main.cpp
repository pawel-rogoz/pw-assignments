#include <iostream>
#include <vector>
#include <string>
#include "monitor.h"

int const threadsCounts = 5;

int const bufferSize = 2;

int const maxIterations = 20;

class Buffer
{
protected:
    std::vector<int> values;
    std::string name;

    void print()
    {
        std::cout << "\n ###" << name << " " << values.size() << "[";
        for (auto v : values)
            std::cout << v << ",";
        std::cout << "] ###\n";
    }

public:
    Buffer()
    {
        this->name = "unnamed buffer";
    }

    Buffer(std::string name)
    {
        this->name = name;
    }

    void put(int value, int prodId)
    {
        values.push_back(value);
        std::cout << "Producent " << prodId << " pushed: " << value << " to buffer " << name << "\n";
        print();
    }

    int get(int consId)
    {
        auto value = values.front();
        values.erase(values.begin());
        std::cout << "Consumer " << consId << " took: " << value << " from buffer " << name << "\n";
        print();
        return value;
    }
};


class SmartBuffer : public Buffer {
private:
    Semaphore full;
    Semaphore empty;
    Semaphore mutex;
public:
    SmartBuffer(std::string name)
        : full(bufferSize), empty(0), mutex(1)
    {
        this->name = name;
    }

    void put(int value, int prodId)
    {
        full.p();
        mutex.p();
        Buffer::put(value, prodId);
        empty.v();
        mutex.v();
    }

    int get(int consId)
    {
        empty.p();
        mutex.p();
        auto value = Buffer::get(consId);
        full.v();
        mutex.v();
        return value;
    }
};


std::vector<SmartBuffer> buffers;

void* threadProd(void* arg)
{
    int prodId = *((int*)arg);
    int bufferId = prodId - 1;

    int i = 0;

    while(i < maxIterations)
    {
        int value = 10 * prodId + std::rand() % 10;
        buffers[bufferId].put(value, prodId);
        i++;
    }

    return NULL;
}

void* threadCons(void* arg)
{
    int consId = *((int*)arg);
    int bufferIds[2];

    if (consId == 1)
    {
        bufferIds[0] = 0;
        bufferIds[1] = 1;
    }
    else if (consId == 2)
    {
        bufferIds[0] = 1;
        bufferIds[1] = 2;
    }

    int index = 0;

    int i = 0;

	while (i < maxIterations)
	{
		auto value = buffers[bufferIds[index]].get(consId);
        index = (index + 1) % 2;
        i++;
	}

	return NULL;
}

int main()
{
    buffers.push_back(SmartBuffer("buffer1"));
    buffers.push_back(SmartBuffer("buffer2"));
    buffers.push_back(SmartBuffer("buffer3"));

#ifdef _WIN32
	HANDLE tid[threadsCounts];
	DWORD id;

	tid[0] = CreateThread(NULL, 0, (LPTHREAD_START_ROUTINE)threadProd, 0, 0, &id);
	tid[1] = CreateThread(NULL, 0, (LPTHREAD_START_ROUTINE)threadProd, 0, 0, &id);
	tid[2] = CreateThread(NULL, 0, (LPTHREAD_START_ROUTINE)threadProd, 0, 0, &id);
	tid[3] = CreateThread(NULL, 0, (LPTHREAD_START_ROUTINE)threadConsA, 0, 0, &id);
	tid[4] = CreateThread(NULL, 0, (LPTHREAD_START_ROUTINE)threadConsB, 0, 0, &id);

	for (int i = 0; i <= threadsCounts; i++)
		WaitForSingleObject(tid[i], INFINITE);
#else
	pthread_t tid[threadsCounts];

    int prodIds[3] = {1, 2, 3};
    int consIds[2] = {1, 2};

	pthread_create(&(tid[0]), NULL, threadProd, (void*)&prodIds[0]);
    pthread_create(&(tid[1]), NULL, threadProd, (void*)&prodIds[1]);
	pthread_create(&(tid[2]), NULL, threadProd, (void*)&prodIds[2]);
	pthread_create(&(tid[3]), NULL, threadCons, (void*)&consIds[0]);
	pthread_create(&(tid[4]), NULL, threadCons, (void*)&consIds[1]);

	for (int i = 1; i < threadsCounts; i++)
		pthread_join(tid[i], (void**)NULL);
#endif
	return 0;
}
