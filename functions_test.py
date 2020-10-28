from functions import correct_parenthesize


def test_corrections():
    inp = [
        ('tis', 'het is', 'tis [: het is]'),
        ('kliken', 'klikken', 'kli(k)ken'),
        ('kunne', 'kunnen', 'kunne(n)')
    ]

    for org, corr, exp in inp:
        assert correct_parenthesize(org, corr) == exp
