#!/usr/bin/env python3

from collections import defaultdict
from string import ascii_uppercase

import re

with open('../input.txt') as f:
    content = f.readlines()

# (prerequisite, task)
def parse_line(line):
    match = re.match(r'Step (\w) must be finished before step (\w) can begin.', line)
    return match.group(1), match.group(2)

class Task:
    def __init__(self, name, duration):
        self.name = name
        self.duration = duration
        self.requirements = set()

    def add_requirement(self, task):
        self.requirements.add(task)

class Worker:
    def __init__(self):
        self.task = None
        self.time_left = 0

    def assign_task(self, task):
        self.task = task
        self.time_left = task.duration

    def do_work(self):
        if (self.time_left == 0):
            raise Exception("No work to do")
        self.time_left -= 1
        if (self.time_left == 0):
            self.task = None

    def is_busy(self):
        return self.time_left != 0

def get_ordered_tasks(tasks):
    # remaining tasks are kept in alphabetical order
    remaining_tasks = sorted(list(tasks), key=(lambda task: task.name))
    sorted_tasks = []

    while remaining_tasks:
        for task in remaining_tasks:
            if not task.requirements - set(sorted_tasks):
                sorted_tasks.append(task)
                remaining_tasks.remove(task)
                break

    return sorted_tasks


tasks = set()
for letter in ascii_uppercase:
    duration = 60 + (ord(letter) - 64)
    tasks.add(Task(letter, duration))

# Add requirements
for line in content:
    req, step = parse_line(line)
    req_task = next(task for task in tasks if task.name == req)
    step_task = next(task for task in tasks if task.name == step)
    step_task.add_requirement(req_task)

ordered_tasks = get_ordered_tasks(tasks)

# Work the tasks
seconds = 0
workers = [Worker() for _ in range(5)]
remaining_tasks = ordered_tasks.copy()
completed_tasks = []
while remaining_tasks or (True in [worker.is_busy() for worker in workers]):
    # Assign tasks
    for worker in workers:
        if remaining_tasks and not worker.is_busy():
            for task in remaining_tasks:
                if not task.requirements - set(completed_tasks):
                    worker.assign_task(task)
                    remaining_tasks.remove(task)
                    break
    # Print table
    print(seconds, end=' ')
    for worker in workers:
        if worker.task:
            print(worker.task.name, end=' ')
        else:
            print(".", end=' ')

    # Do work and check for finished tasks
    for worker in workers:
        if worker.is_busy():
            task = worker.task
            worker.do_work()
            if not worker.is_busy():
                completed_tasks.append(task)

    print()
    seconds += 1

print(seconds) 

