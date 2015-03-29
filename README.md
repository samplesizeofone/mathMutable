# mathMutable
Allows the creation of references to values which can change over time without resorting to Holds or down values. Note this is in the early stages of development and almost certainly contains bugs and rough edges.

By way of example

    m = creatueMutable[1];
    m[]

gives

    1

A slightly more complex example

    f[m_] :=
        Do[
            m[[y, x]] = m[[y, x]] + 1,
            {y, Length[m[]]},
            {x, Min[Length /@ m[]]}
        ]
    matrix =
        createMutable[
            {
                {0, 0},
                {0, 0}
            }
        ];
    f[matrix];
    matrix[]

yields

    {
        {1, 1},
        {1, 1}
    }

See Manual.nb for the motivation for mathMutable and instructions.