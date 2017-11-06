import pytest

def test_func_fast():
    pass

@pytest.mark.slow
def test_func_slow():
    pass




if __name__ == '__main__':
    test_func_slow()
