//! Isolated K12 exact-capacity port; no production/default changes.
mod four_sector_range12;
mod layout_parallel;
mod parallel;
pub use four_sector_range12::FourSectorRange12BloomFilter;
#[derive(Debug, Clone, Copy, PartialEq, Eq)]
pub enum SizeError { InvalidSize, CapacityExceeded }
impl std::fmt::Display for SizeError {
    fn fmt(&self, f: &mut std::fmt::Formatter<'_>) -> std::fmt::Result { write!(f,"{self:?}") }
}
impl std::error::Error for SizeError {}
