#ifndef READ_COUNT_H
#define READ_COUNT_H

#include "diffhic.h"

struct coord {
    coord (const int& a, const int& t, const int& l) : anchor(a), target(t), library(l) {}
	bool operator> (const coord& other) const {
		if (anchor > other.anchor) { return true; }
		else if (anchor == other.anchor) { return target>other.target; }
		else { return false; }
	}
	int anchor, target, library;
};

typedef std::priority_queue<coord, std::deque<coord>, std::greater<coord> > pair_queue;

int setup_pair_data (Rcpp::List, std::vector<Rcpp::IntegerVector>&, std::vector<Rcpp::IntegerVector>&, std::vector<int>&, std::vector<int>&);

class binner {
public:
	binner(SEXP, SEXP, int, int);

	void fill();
	bool empty() const;
	int get_nlibs() const;
	int get_nbins() const;
	int get_anchor() const;

    const std::vector<int>& get_counts() const;
    const std::deque<int>& get_changed() const;
private:
	const int fbin, lbin, nbins;
	int nlibs;
    Rcpp::IntegerVector binid;

    std::vector<Rcpp::IntegerVector> anchor1, anchor2;
	std::vector<int> nums, indices;

    pair_queue next;
	int curab;

    // Stuff that is visible to the calling class.
    std::vector<int> curcounts;
    std::vector<int> ischanged;
    std::deque<int> waschanged;
};

#endif
