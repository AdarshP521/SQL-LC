from collections import deque
from typing import List

class Solution:
    def maximumInvitations(self, favorite: List[int]) -> int:
        n = len(favorite)
        in_degree = [0] * n
        
        # Step 1: Calculate in-degrees for topological sort
        for person in favorite:
            in_degree[person] += 1
            
        # Step 2: Use Kahn's algorithm to strip away non-cycle nodes (trees leading into cycles)
        queue = deque([i for i in range(n) if in_degree[i] == 0])
        # max_depth[i] stores the length of the longest chain ending at node i
        max_depth = [1] * n
        
        while queue:
            u = queue.popleft()
            v = favorite[u]
            max_depth[v] = max(max_depth[v], max_depth[u] + 1)
            in_degree[v] -= 1
            if in_degree[v] == 0:
                queue.append(v)
                
        # Step 3: Find cycles and evaluate the two seating scenarios
        max_cycle_len = 0
        sum_two_cycles = 0
        
        visited = [False] * n
        
        for i in range(n):
            # If in_degree[i] > 0, it means node i is part of a cycle
            if not visited[i] and in_degree[i] > 0:
                # Traverse the cycle to measure its length and find all members
                cycle_nodes = []
                curr = i
                while not visited[curr]:
                    visited[curr] = True
                    cycle_nodes.append(curr)
                    curr = favorite[curr]
                
                cycle_len = len(cycle_nodes)
                
                if cycle_len == 2:
                    # Scenario A: 2-cycle (A <-> B)
                    # We can add the longest chain feeding into A and the longest chain feeding into B
                    u, v = cycle_nodes[0], cycle_nodes[1]
                    sum_two_cycles += max_depth[u] + max_depth[v]
                else:
                    # Scenario B: Cycle of length > 2
                    max_cycle_len = max(max_cycle_len, cycle_len)
                    
        # The answer is the maximum between the single largest long cycle 
        # or the sum of all 2-cycles plus their attached chains.
        return max(max_cycle_len, sum_two_cycles)