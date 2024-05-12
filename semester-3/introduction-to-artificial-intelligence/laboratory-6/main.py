import numpy as np
import gymnasium as gym

def q_learning(environment, action_type, e_max = 5000, t_max = 100, gamma = 0.3, min_exploration_rate = 0.01, exploration_rate = 1.0, exploration_decreasing_decay = 0.001, learning_rate = 0.5):
    n_observation = environment.observation_space.n
    n_action = environment.action_space.n
    Q = np.zeros((n_observation, n_action))
    e = 0
    episodes_rewards = list()
    while e < e_max:
        t = 0
        done = False
        episode_reward = 0
        current_state = environment.reset()[0]
        while t < t_max:
            action = choose_action(environment, exploration_rate, Q, current_state, action_type, t, n_action)
            next_state, reward, done = do_action(environment, action)
            Q[current_state, action] = (1-learning_rate) * Q[current_state, action] + learning_rate * (reward + gamma * max(Q[next_state,:]))
            episode_reward += reward
            if done:
                break
            current_state = next_state
            t += 1
        exploration_rate = max(min_exploration_rate, np.exp(-exploration_decreasing_decay*e))
        episodes_rewards.append(episode_reward)
        e += 1
    return Q, episodes_rewards

def test(Q, t_max, environment):
    t = 0
    current_state = environment.reset()[0]
    test_reward = 0
    while t < t_max:
        action = np.argmax(Q[current_state,:])
        next_state, reward, done, _, _ = environment.step(action)
        test_reward += reward
        if done:
            break
        current_state = next_state
        t += 1
    return test_reward


def choose_action(environment, exploration_rate, Q, current_state, action_type, t, n_action):
    if action_type == 'epsilon':
        if np.random.uniform(0,1) < exploration_rate:
            action = environment.action_space.sample()
        else:
            action = np.argmax(Q[current_state,:])
    elif action_type == 'boltzmann':
        p = []
        sum = 0
        for i in range(n_action):
            p.append((np.exp(Q[current_state][i]/np.exp(-t))))
            sum += p[i]
        p = [p[i]/sum for i in range(len(p))]
        action = np.random.choice(n_action, 1, p)[0]
    return action

def do_action(environment, action):
    next_state, reward, done, _, _ = environment.step(action)
    return next_state, reward, done


def main():
    environment = gym.make('Taxi-v3', render_mode = 'rgb_array')
    Q, _ = q_learning(environment, 'epsilon')
    environment.close()

    environment = gym.make('Taxi-v3', render_mode = 'human')
    reward = test(Q, 100, environment)
    environment.close()
    print(reward)


if __name__ == "__main__":
    main()