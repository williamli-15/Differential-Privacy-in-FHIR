# Differential-Privacy-in-FHIR

## Differential Privacy in GoogleSQL for BigQuery

### How It Works

1. **Per-Entity Aggregations**: The query computes per-entity aggregations for each group specified with a GROUP BY clause.

2. **Limiting Group Contributions**: The number of groups each entity can contribute to is limited based on the `max_groups_contributed` differential privacy parameter.

3. **Clamping Bounds**: Each per-entity aggregate contribution is clamped within specified bounds. If clamping bounds are not explicitly provided, they are calculated implicitly in a differentially private manner.

4. **Aggregation**: The clamped per-entity aggregate contributions are aggregated for each group.

5. **Adding Noise**: Random noise is added to the final aggregate value for each group. The scale of the noise is determined by all of the clamped bounds and privacy parameters.

6. **Noisy Entity Count**: A noisy entity count is computed for each group, and groups with few entities are eliminated. This helps in eliminating a non-deterministic set of groups.

The final result of the query is a dataset where each group has noisy aggregate results, and small groups that could potentially lead to privacy breaches have been eliminated.
